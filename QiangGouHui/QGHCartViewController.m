//
//  QGHCartViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/13.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHCartViewController.h"
#import "QGHCartCell.h"
#import "MMHNetworkAdapter+Cart.h"


static NSString *const QGHCartCellIdentifier = @"QGHCartCellIdentifier";


@interface QGHCartViewController ()<UITableViewDataSource, UITableViewDelegate, QGHCartCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray<QGHCartItem *> *cartItemArr;
@property (nonatomic, strong) UILabel *sumLabel;
@property (nonatomic, strong) UIButton *allSelectButton;

@end


@implementation QGHCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeTableView];
    [self makeBottomView];
    
    [self fetchData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
  
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHCartCell" bundle:nil] forCellReuseIdentifier:QGHCartCellIdentifier];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];
}


- (void)makeBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 48)];
    [bottomView setBottom:self.view.height];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView addTopSeparatorLine];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mmh_screen_width());
        make.height.mas_equalTo(48);
        make.bottom.equalTo(self.view);
    }];
    
    
    UIButton *allSelectButton = [[UIButton alloc] init];
    [allSelectButton setImage:[UIImage imageNamed:@"dizhi_weixuanzhong"] forState:UIControlStateNormal];
    [allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectButton setTitleColor:C7 forState:UIControlStateNormal];
    allSelectButton.titleLabel.font = F3;
    allSelectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    allSelectButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [allSelectButton sizeToFit];
    allSelectButton.width += 10;
    allSelectButton.centerY = bottomView.height * 0.5;
    allSelectButton.x = 15;
    [allSelectButton addTarget:self action:@selector(allSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:allSelectButton];
    self.allSelectButton = allSelectButton;
    
    
    UIButton *buyNowButton = [[UIButton alloc] initWithFrame:CGRectMake(mmh_screen_width() - 110, 0, 110, 48)];
    buyNowButton.backgroundColor = C20;
    [buyNowButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyNowButton setTitleColor:C21 forState:UIControlStateNormal];
    buyNowButton.titleLabel.font = F5;
    [buyNowButton addTarget:self action:@selector(buyNowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyNowButton];
    
    _sumLabel = [[UILabel alloc] init];
    _sumLabel.font = F3;
    _sumLabel.textColor = C8;
    _sumLabel.textAlignment = NSTextAlignmentRight;
    _sumLabel.height = 48;
    _sumLabel.x = allSelectButton.right + 16;
    [_sumLabel setMaxX:buyNowButton.x - 16];
    _sumLabel.y = 0;
    _sumLabel.text = @"合计：";
    [bottomView addSubview:_sumLabel];
}


#pragma mark - network


- (void)fetchData {
    [[MMHNetworkAdapter sharedAdapter] fetchCartListFrom:self succeededHandler:^(NSArray<QGHCartItem *> *itemArr) {
        self.cartItemArr = [NSMutableArray arrayWithArray:itemArr];
        [self.tableView reloadData];
        [self.allSelectButton setImage:[UIImage imageNamed:@"dizhi_xuanzhong"] forState:UIControlStateNormal];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cartItemArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHCartCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHCartCellIdentifier forIndexPath:indexPath];
    QGHCartItem *item = [self.cartItemArr objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.cartItem = item;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}


#pragma mark - QGHCartCellDelegate


- (void)cartCellModifyCount:(QGHCartCell *)cell changeValueFrom:(NSInteger)currentValue to:(NSInteger)newValue {
    [self.view showProcessingView];
    [[MMHNetworkAdapter sharedAdapter] modifyCartCountFrom:self goodsId:cell.cartItem.good_id count:cell.cartItem.count price: [NSString stringWithFormat:@"%g", cell.cartItem.min_price] itemId:cell.cartItem.itemId succeededHandler:^{
        [self.view hideProcessingView];
        cell.cartItem.count = (int)newValue;
        [self.tableView reloadData];
    } failedHandler:^(NSError *error) {
        [self.view hideProcessingView];
        [self.view showTipsWithError:error];
    }];
}


- (void)cartCellDeleteItem:(QGHCartCell *)cell {
    [self.view showProcessingView];
    [[MMHNetworkAdapter sharedAdapter] deleteCartItemFrom:self itemId:cell.cartItem.itemId succeededHandler:^{
        [self.view hideProcessingView];
        [self.cartItemArr removeObject:cell.cartItem];
        [self.tableView reloadData];
    } failedHandler:^(NSError *error) {
        [self.view hideProcessingView];
        [self.view showTipsWithError:error];
    }];
}


- (void)cartCellSelectItem:(QGHCartCell *)cell {
    BOOL allSelected = YES;
    float sumPrice = 0;
    for (QGHCartItem *item in self.cartItemArr) {
        if (item.isSelected) {
            sumPrice += item.min_price;
        } else {
            allSelected = NO;
        }
    }
    
    if (allSelected) {
        [self.allSelectButton setImage:[UIImage imageNamed:@"dizhi_xuanzhong"] forState:UIControlStateNormal];
    } else {
        [self.allSelectButton setImage:[UIImage imageNamed:@"dizhi_weixuanzhong"] forState:UIControlStateNormal];
    }
    
    [self setSumPrice:sumPrice];
}


- (void)setSumPrice:(float)sumPrice {
    NSString *bigString = [NSString stringWithFormat:@"¥%g", sumPrice];
    NSString *string = [NSString stringWithFormat:@"合计：%@", bigString];
    NSRange bigRange = [string rangeOfString:bigString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:@{NSFontAttributeName: F7} range:bigRange];
    self.sumLabel.attributedText = attributedString;
}


#pragma mark - Action


- (void)allSelectButtonAction {
    BOOL allSelected = YES;
    float sumPrice = 0;
    for (QGHCartItem *item in self.cartItemArr) {
        if (!item.isSelected) {
            allSelected = NO;
        }
        
        sumPrice += item.min_price;
    }
    
    if (allSelected) {
         [self setSumPrice:0];
    } else {
        [self setSumPrice:sumPrice];
    }
   
    
    if (allSelected) {
        [self.allSelectButton setImage:[UIImage imageNamed:@"dizhi_weixuanzhong"] forState:UIControlStateNormal];
    } else {
        [self.allSelectButton setImage:[UIImage imageNamed:@"dizhi_xuanzhong"] forState:UIControlStateNormal];
    }

    for (QGHCartItem *item in self.cartItemArr) {
        item.isSelected = !allSelected;
    }
    
    [self.tableView reloadData];
}


- (void)buyNowButtonAction {
    //TODO
}


@end

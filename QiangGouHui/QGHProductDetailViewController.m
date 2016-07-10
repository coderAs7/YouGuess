//
//  QGHProductDetailVIewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/1.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductDetailVIewController.h"
#import "MMHProductDetailHeaderCell.h"
#import "QGHProductDetailPriceCell.h"
#import "QGHProductDetailCommentCell.h"
#import "QGHProductDetailInfoCell.h"
#import "QGHConfirmOrderViewController.h"
#import "MMHNetworkAdapter+Product.h"
#import "QGHProductDetailWebViewCell.h"
#import "MMHProductSpecSelectionViewController.h"
#import "MMHNetworkAdapter+Cart.h"


static NSString *const QGHProductDetailHeaderCellIdentifier = @"QGHProductDetailHeaderCellIdentifier";
static NSString *const QGHProductDetailPriceCellIdentifier = @"QGHProductDetailPriceCellIdentifier";
static NSString *const QGHProductDetailProductTitleCellIdentifier = @"QGHProductDetailProductTitleCellIdentifier";
static NSString *const QGHProductDetailCommentTitleCellIdentifier = @"QGHProductDetailCommentTitleCellIdentifier";
static NSString *const QGHProductCommentCellIdentifier = @"QGHProductCommentCellIdentifier";
static NSString *const QGHProductDetailImageTitleCellIdentifier = @"QGHProductDetailImageTitle";
static NSString *const QGHProductDetailImageCellIdentifier = @"QGHProductDetailImageCellIdentifier";


@interface QGHProductDetailVIewController ()<UITableViewDelegate, UITableViewDataSource, QGHProductDetailWebViewCellDelegate>

@property (nonatomic, assign) QGHBussType bussType;
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) CGFloat productDetaiImageHeight;

@property (nonatomic, strong) QGHProductDetailModel *productDetailModel;
@property (nonatomic, strong) QGHProductDetailScoreInfo *scoreInfo;
@property (nonatomic, strong) NSArray<QGHProductDetailComment *> *comments;

@end


@implementation QGHProductDetailVIewController


- (instancetype)initWithBussType:(QGHBussType)type goodsId:(NSString *)goodsId {
    self = [super init];
    
    if (self) {
        _bussType = type;
        _goodsId = goodsId;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"xiangqing_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    [self makeTableView];
    [self makeBottomView];
    [self fetchData];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[MMHProductDetailHeaderCell class] forCellReuseIdentifier:QGHProductDetailHeaderCellIdentifier];
    [_tableView registerClass:[QGHProductDetailPriceCell class] forCellReuseIdentifier:QGHProductDetailPriceCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHProductDetailInfoCell" bundle:nil] forCellReuseIdentifier:QGHProductDetailProductTitleCellIdentifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:QGHProductDetailCommentTitleCellIdentifier];
    [_tableView registerClass:[QGHProductDetailCommentCell class] forCellReuseIdentifier:QGHProductCommentCellIdentifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:QGHProductDetailImageTitleCellIdentifier];
    [_tableView registerClass:[QGHProductDetailWebViewCell class] forCellReuseIdentifier:QGHProductDetailImageCellIdentifier];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];
}


- (void)makeBottomView {
    _bottomView = [[UIView alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"pro_btn_kefu"];
    NSString *title = @"客服";
    CGSize titleSize = [title sizeWithFont:F3 constrainedToWidth:CGFLOAT_MAX lineCount:1];
    UIButton *customerServiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 48)];
    [customerServiceBtn setImage:image forState:UIControlStateNormal];
    [customerServiceBtn setTitle:title forState:UIControlStateNormal];
    customerServiceBtn.titleLabel.font = F3;
    [customerServiceBtn setTitleColor:C7 forState:UIControlStateNormal];
    [customerServiceBtn setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height, titleSize.width, 0, 0)];
    [customerServiceBtn setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height, -image.size.width, 0, 0)];
    [_bottomView addSubview:customerServiceBtn];
    
    image = [UIImage imageNamed:@"pro_btn_shopping_n"];
    title = @"购物车";
    titleSize = [title sizeWithFont:F3 constrainedToWidth:CGFLOAT_MAX lineCount:1];
    UIButton *cartBtn = [[UIButton alloc] initWithFrame:CGRectMake(75, 0, 75, 48)];
    [cartBtn setImage:image forState:UIControlStateNormal];
    [cartBtn setTitle:title forState:UIControlStateNormal];
    cartBtn.titleLabel.font = F3;
    [cartBtn setTitleColor:C7 forState:UIControlStateNormal];
    [cartBtn setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height, (titleSize.width - image.size.width), 0, 0)];
    [cartBtn setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height, -image.size.width, 0, 0)];
    [_bottomView addSubview:cartBtn];
    
    if (self.bussType == QGHBussTypeAppoint && self.bussType == QGHBussTypeCustom) {
        UIButton *appointBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, mmh_screen_width() - 150, 75)];
        appointBtn.backgroundColor = C20;
        [appointBtn setTitle:@"立即预约" forState:UIControlStateNormal];
        [appointBtn setTitleColor:C21 forState:UIControlStateNormal];
        appointBtn.titleLabel.font = F6;
        [_bottomView addSubview:appointBtn];
    } else {
        UIButton *addCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, (mmh_screen_width() - 150) * 0.5, 48)];
        addCartBtn.backgroundColor = C20;
        [addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [addCartBtn setTitleColor:C21 forState:UIControlStateNormal];
        addCartBtn.titleLabel.font = F6;
        [addCartBtn addTarget:self action:@selector(addCartBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:addCartBtn];
        
        UIButton *buyNowBtn = [[UIButton alloc] initWithFrame:CGRectMake(addCartBtn.right, 0, (mmh_screen_width() - 150) * 0.5, 48)];
        buyNowBtn.backgroundColor = RGBCOLOR(252, 43, 70);
        [buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyNowBtn.titleLabel.font = F6;
        [buyNowBtn addTarget:self action:@selector(buyNowBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:buyNowBtn];
    }
    [_bottomView addTopSeparatorLine];
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(mmh_screen_width());
        make.height.mas_equalTo(48);
    }];
}


#pragma mark - network


- (void)fetchData {
    if (![[MMHAccountSession currentSession] alreadyLoggedIn]) {
        return;
    }
    
    [[MMHNetworkAdapter sharedAdapter] fetchDataWithRequester:self goodsId:self.goodsId succeededHandler:^(QGHProductDetailModel *productDetailModel) {
        self.productDetailModel = productDetailModel;
        [self.tableView reloadData];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
    
    
    [[MMHNetworkAdapter sharedAdapter] fetchProductCommentsWithRequester:self goodsId:self.goodsId page:1 size:10 succeededHandler:^(QGHProductDetailScoreInfo *scoreInfo, NSArray<QGHProductDetailComment *> *commentArr) {
        self.scoreInfo = scoreInfo;
        self.comments = commentArr;
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        NSInteger count = (self.comments.count > 2) ? 2 : self.comments.count;
        return 1 + count;
    } else {
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MMHProductDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailHeaderCellIdentifier forIndexPath:indexPath];
            NSString *imageUrl = self.productDetailModel.product.img_path;
            if (imageUrl.length) {
                cell.imageArray = @[imageUrl];
            }
            return cell;
        } else if (indexPath.row == 1) {
            QGHProductDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailPriceCellIdentifier forIndexPath:indexPath];
            [cell setData:self.productDetailModel];
            return cell;
        } else {
            QGHProductDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailProductTitleCellIdentifier forIndexPath:indexPath];
            [cell setData:self.productDetailModel];
            return cell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailCommentTitleCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"商品评价(%@条，%@好评率)", self.scoreInfo.count, self.scoreInfo.star];
            cell.textLabel.font = F5;
            cell.textLabel.textColor = C8;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else {
            QGHProductDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductCommentCellIdentifier forIndexPath:indexPath];
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailImageTitleCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"商品介绍";
            cell.textLabel.font = F3;
            cell.textLabel.textColor = C6;
            
            return cell;
        } else {
            QGHProductDetailWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailImageCellIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            [cell setProductDetailUrl:self.productDetailModel.product.info];
            
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return mmh_screen_width();
        } else if (indexPath.row == 1) {
            return 50;
        } else {
            return 95;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 48;
        } else {
            return 89;
        }
    } else {
        if (indexPath.row == 0) {
            return 43;
        } else {
            return self.productDetaiImageHeight;
        }
    }
}


#pragma mark - QGHProductDetailWebViewCellDelegate


- (void)productDetailWebViewCellLoadedFinish:(CGFloat)webViewContentHeight {
    self.productDetaiImageHeight = webViewContentHeight;
    [self.tableView reloadData];
}

#pragma mark - Action


- (void)shareAction {
    
}


- (void)addCartBtnAction {
    MMHProductSpecSelectionViewController *specVC = [[MMHProductSpecSelectionViewController alloc] initWithProductDetail:self.productDetailModel specSelectedHandler:^(QGHSKUSelectModel *selectedSpec) {
        [[MMHNetworkAdapter sharedAdapter] addCartFrom:self goodsId:self.productDetailModel.product.goodsId count:selectedSpec.count price:self.productDetailModel.product.min_price skuId:self.productDetailModel.allSepcSelectedPrice.priceId succeededHandler:^{
            //TODO
        } failedHandler:^(NSError *error) {
            [self.view showTipsWithError:error];
        }];
    }];
    QGHTabBarController *tabBarController = (QGHTabBarController *)self.tabBarController;
    [tabBarController presentFloatingViewController:specVC animated:YES];

}


- (void)buyNowBtnAction {
    MMHProductSpecSelectionViewController *specVC = [[MMHProductSpecSelectionViewController alloc] initWithProductDetail:self.productDetailModel specSelectedHandler:^(QGHSKUSelectModel *selectedSpec) {
        QGHConfirmOrderViewController *confirmOrderVC = [[QGHConfirmOrderViewController alloc] initWithBussType:QGHBussTypeNormal productDetail:self.productDetailModel];
        [self.navigationController pushViewController:confirmOrderVC animated:YES];
    }];
    QGHTabBarController *tabBarController = (QGHTabBarController *)self.tabBarController;
    [tabBarController presentFloatingViewController:specVC animated:YES];
}


@end

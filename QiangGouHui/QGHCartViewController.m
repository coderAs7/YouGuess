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


@interface QGHCartViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;

@end


@implementation QGHCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeTableView];
    
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
    
}


#pragma mark - network


- (void)fetchData {
    [[MMHNetworkAdapter sharedAdapter] fetchCartListFrom:self succeededHandler:^(NSArray<QGHCartItem *> *itemArr) {
        
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHCartCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHCartCellIdentifier forIndexPath:indexPath];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}


@end

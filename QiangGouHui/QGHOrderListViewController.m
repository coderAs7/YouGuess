//
//  QGHOrderListViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/25.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderListViewController.h"
#import "QGHOrderListCell.h"
#import "MMHUnderlinedSegmentedControl.h"
#import "QGHOrderDetailViewController.h"
#import "QGHLogisticsDetailViewController.h"


static NSString *const QGHOrderListCellIdentifier = @"QGHOrderListCellIdentifier";


@interface QGHOrderListViewController ()<UITableViewDataSource, UITableViewDelegate, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, QGHOrderListCellDelegate>

@property (nonatomic, strong) NSArray *segmentItemArray;
@property (nonatomic, strong) MMHUnderlinedSegmentedControl *segmentList;
@property (nonatomic, strong) UITableView *orderTableView;

@end


@implementation QGHOrderListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    
    [self createSegment];
    [self makeTableView];
}

- (void)createSegment {
    self.segmentList = [[MMHUnderlinedSegmentedControl alloc] init];
    self.segmentList.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    self.segmentList.delegate = self;
    self.segmentList.dataSource = self;
    [self.segmentList setTitleColor:C7 forState:UIControlStateNormal];
    self.segmentList.font = F4;
    self.segmentList.selectionIndicatorColor = RGBCOLOR(254, 204, 47);
    self.segmentList.bottomTrimColor = [UIColor colorWithHexString:@"dcdcdc"];
    [self.segmentList setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.segmentItemArray = @[@" 全部 ", @" 待付款 ", @" 待收货 ", @" 待评价 ", @"已完成 ", @"已取消", @" 退款退货 "];
    [self.view addSubview:self.segmentList];
//    [self.segmentList setSelectedButtonIndex:self.transferItemSelected animated:YES];
//    [self.segmentList.delegate selectionList:self.segmentList didSelectButtonWithIndex:self.transferItemSelected];
}

- (void)makeTableView {
    _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, mmh_screen_width(), mmh_screen_height() - 40) style:UITableViewStyleGrouped];
    _orderTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _orderTableView.dataSource = self;
    _orderTableView.delegate = self;
    [_orderTableView registerNib:[UINib nibWithNibName:@"QGHOrderListCell" bundle:nil] forCellReuseIdentifier:QGHOrderListCellIdentifier];
//    [_orderTableView registerClass:[MMHPersonalCenterAllOrderCell class] forCellReuseIdentifier:QGHPersonalCenterOrderCellIdentifier];
//    _orderTableView.tableHeaderView = [self personalCenterHeaderView];
    _orderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_orderTableView];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderListCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHOrderDetailViewController *orderDetailVC = [[QGHOrderDetailViewController alloc] init];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}


#pragma mark - HTHorizontalSelectionListDataSource and Delegate


- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.segmentItemArray.count;
}


- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return [self.segmentItemArray objectAtIndex:index];
}


- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    //TODO
}


#pragma mark - QGHOrderListCellDelegate


- (void)orderListCellDidClickButton1:(QGHOrderListCell *)cell {
    QGHLogisticsDetailViewController *logisticsDetailVC = [[QGHLogisticsDetailViewController alloc] init];
    [self.navigationController pushViewController:logisticsDetailVC animated:YES];
}


@end

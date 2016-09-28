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
#import "MMHNetworkAdapter+Order.h"
#import "QGHOrderList.h"
#import "QGHOrderListBottomCell.h"
#import "MMHPayWayViewController.h"
#import "AppWebViewController.h"
#import "MMHChatCustomerViewController.h"
#import "QGHCommentViewController.h"


static NSString *const QGHOrderListTitleCellIdentifier = @"QGHOrderListTitleCellIdentifier";
static NSString *const QGHOrderListCellIdentifier = @"QGHOrderListCellIdentifier";
static NSString *const QGHOrderListBottomCellIdentifier = @"QGHOrderListBottomCellIdentifier";


@interface QGHOrderListViewController ()<UITableViewDataSource, UITableViewDelegate, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, QGHOrderListCellDelegate, MMHTimelineDelegate, QGHOrderListBottomCellDelegate, QGHOrderDetailViewControllerDelegate>

@property (nonatomic, strong) NSArray *segmentItemArray;
@property (nonatomic, strong) MMHUnderlinedSegmentedControl *segmentList;
@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSArray<QGHOrderList *> *orderListArr;
@property (nonatomic, strong) NSArray *statusArr;

@end


@implementation QGHOrderListViewController


- (instancetype)init {
    self = [super init];
    
    if (self) {
        _selectedStatus = QGHOrderListItemStatusAll;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    
    [self createSegment];
    [self makeOrderListArr];
    [self makeTableView];
    
    [self fetchData];
    
    NSInteger selectedIndex = [self.statusArr indexOfObject:@(_selectedStatus)];
    self.segmentList.selectedButtonIndex = selectedIndex;
    [self.segmentList makeCurrentSelectionVisible];
}


- (void)createSegment {
    self.segmentList = [[MMHUnderlinedSegmentedControl alloc] init];
//    self.segmentList.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    self.segmentList.delegate = self;
    self.segmentList.dataSource = self;
    [self.segmentList setTitleColor:C7 forState:UIControlStateNormal];
    self.segmentList.font = F4;
    self.segmentList.selectionIndicatorColor = RGBCOLOR(254, 204, 47);
    self.segmentList.bottomTrimColor = [UIColor colorWithHexString:@"dcdcdc"];
    [self.segmentList setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.segmentItemArray = @[@" 全部 ", @" 待付款 ", @" 待发货 ", @" 待收货 ", @" 待评价 ", @"已完成 ", @" 退款退货 "];
    [self.view addSubview:self.segmentList];
    
    [self.segmentList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mmh_screen_width());
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
    }];
//    [self.segmentList setSelectedButtonIndex:self.transferItemSelected animated:YES];
//    [self.segmentList.delegate selectionList:self.segmentList didSelectButtonWithIndex:self.transferItemSelected];
}


- (void)makeOrderListArr {
    NSMutableArray *orderListArr = [[NSMutableArray alloc] init];
    NSArray *statusArr = @[@(QGHOrderListItemStatusAll), @(QGHOrderListItemStatusToPay), @(QGHOrderListItemStatusToExpress), @(QGHOrderListItemStatusToReceipt), @(QGHOrderListItemStatusToComment), @(QGHOrderListItemStatusFinish), @(QGHOrderListItemStatusRefund)];
    _statusArr = statusArr;
    for (NSNumber *statusNum in statusArr) {
        QGHOrderList *list = [[QGHOrderList alloc] initWithStatus:[statusNum integerValue]];
        list.delegate = self;
        [orderListArr addObject:list];
    }
    
    self.orderListArr = [NSMutableArray arrayWithArray:orderListArr];
}


- (void)makeTableView {
    _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, mmh_screen_width(), mmh_screen_height() - 40) style:UITableViewStyleGrouped];
    _orderTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _orderTableView.dataSource = self;
    _orderTableView.delegate = self;
    [_orderTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:QGHOrderListTitleCellIdentifier];
    [_orderTableView registerNib:[UINib nibWithNibName:@"QGHOrderListCell" bundle:nil] forCellReuseIdentifier:QGHOrderListCellIdentifier];
    [_orderTableView registerNib:[UINib nibWithNibName:@"QGHOrderListBottomCell" bundle:nil] forCellReuseIdentifier:QGHOrderListBottomCellIdentifier];
//    [_orderTableView registerClass:[MMHPersonalCenterAllOrderCell class] forCellReuseIdentifier:QGHPersonalCenterOrderCellIdentifier];
//    _orderTableView.tableHeaderView = [self personalCenterHeaderView];
    _orderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_orderTableView];
    
    [self.orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mmh_screen_width());
        make.top.equalTo(self.segmentList.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}


- (void)fetchData {
    for (QGHOrderList *list in self.orderListArr) {
        [list refetch];
    }
}


- (void)loadMore {
    QGHOrderList *orderList = self.orderListArr[self.segmentList.selectedButtonIndex];
    [orderList fetchMore];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.orderListArr[self.segmentList.selectedButtonIndex] numberOfItems];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QGHOrderList *orderList = self.orderListArr[self.segmentList.selectedButtonIndex];
    QGHOrderListItem *item = [orderList itemAtIndex:section];
    return 2 + item.goodlist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHOrderList *orderList = self.orderListArr[self.segmentList.selectedButtonIndex];
    QGHOrderListItem *item = [orderList itemAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderListTitleCellIdentifier forIndexPath:indexPath];
        cell.textLabel.textColor = C22;
        cell.textLabel.font = F4;
        NSString *statusStr = @"";
        switch (item.status) {
            case QGHOrderListItemStatusToPay:
                statusStr = @"待付款";
                break;
            case QGHOrderListItemStatusToExpress:
                statusStr = @"待发货";
                break;
            case QGHOrderListItemStatusToReceipt:
                statusStr = @"待收货";
                break;
            case QGHOrderListItemStatusToComment:
                statusStr = @"待评价";
                break;
            case QGHOrderListItemStatusFinish:
                statusStr = @"已完成";
                break;
//            case QGHOrderListItemStatusCancel:
//                statusStr = @"已取消";
//                break;
            case QGHOrderListItemStatusRefund:
                statusStr = @"退款退货";
                break;
            default:
                break;
        }
        
        cell.textLabel.text = statusStr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.row == item.goodlist.count + 1) {
        QGHOrderListBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderListBottomCellIdentifier forIndexPath:indexPath];
        cell.item = item;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        QGHOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderListCellIdentifier forIndexPath:indexPath];
        cell.productItem = [item.goodlist objectAtIndex:indexPath.row - 1];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHOrderList *orderList = self.orderListArr[self.segmentList.selectedButtonIndex];
    QGHOrderListItem *item = [orderList itemAtIndex:indexPath.section];
    
    if (indexPath.row != 0 && indexPath.row != item.goodlist.count + 1) {
        QGHOrderDetailViewController *orderDetailVC = [[QGHOrderDetailViewController alloc] initWithOrderId:item.orderId];
        orderDetailVC.delegate = self;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHOrderList *orderList = self.orderListArr[self.segmentList.selectedButtonIndex];
    QGHOrderListItem *item = [orderList itemAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return 40;
    } else if (indexPath.row == item.goodlist.count + 1) {
        return 48;
    } else {
        return 110;
    }
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
    [self.orderTableView reloadData];
}


#pragma mark - QGHOrderListCellDelegate


- (void)orderListCellDidClickButton1:(QGHOrderListCell *)cell {
    QGHLogisticsDetailViewController *logisticsDetailVC = [[QGHLogisticsDetailViewController alloc] init];
    [self.navigationController pushViewController:logisticsDetailVC animated:YES];
}


#pragma mark - MMHTimeline delegate


- (void)timelineDataRefetched:(MMHTimeline *)timeline {
    [self.view hideProcessingView];
    if ([timeline isEqual:self.orderListArr[self.segmentList.selectedButtonIndex]]) {
        [self.orderTableView reloadData];
    }
    
    if ([timeline hasMoreItems]) {
        [self.orderTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    else {
        [self.orderTableView removeFooter];
    }
}


- (void)timelineMoreDataFetched:(MMHTimeline *)timeline {
    [self.view hideProcessingView];
    [self.orderTableView reloadData];
    [self.orderTableView.mj_footer endRefreshing];
    if (![timeline hasMoreItems]) {
        [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
        [self.orderTableView removeFooter];
    }
}


- (void)timeline:(MMHTimeline *)timeline fetchingFailed:(NSError *)error {
    [self.view hideProcessingView];
    [self.orderTableView.mj_header endRefreshing];
    [self.orderTableView.mj_footer endRefreshing];
    [self.view showTipsWithError:error];
}


- (void)timeline:(MMHTimeline *)timeline itemsDeletedAtIndexes:(NSIndexSet *)indexes {
    [self.orderTableView reloadData];
}


#pragma mark - QGHOrderListBottomCellDelegate


- (void)orderListBottomCellToPay:(QGHOrderListBottomCell *)cell {
    MMHPayWayViewController *payWayVC = [[MMHPayWayViewController alloc] initWithPayPrice:cell.item.amount orderNo:cell.item.order_no payWay:^(MMHPayWay payWay) {
        [[MMHPayManager sharedInstance] goToPayManager:cell.item.order_no price:[NSString stringWithFormat:@"%g", cell.item.amount] productTitle:[cell.item getGoodsTitle] payWay:payWay invoker:self successHandler:^{
            [self.navigationController popToViewController:self animated:YES];
        } failHandler:^(NSString *error) {
            [self.view showTips:error];
            [self.navigationController popToViewController:self animated:YES];
        }];
    }];
    [self.navigationController pushViewController:payWayVC animated:YES];
}


- (void)orderListBottomCellToCancel:(QGHOrderListBottomCell *)cell {
    [[MMHNetworkAdapter sharedAdapter] cancelOrderFrom:self orderId:cell.item.orderId succeededHandler:^{
        [self.view showTips:@"取消订单成功"];
        [self fetchData];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


- (void)orderListBottomCellToPayApplyRefunding:(QGHOrderListBottomCell *)cell {
    MMHChatCustomerViewController *customerVC = [[MMHChatCustomerViewController alloc] init];
    customerVC.transferOrderNo = cell.item.order_no;
    [self.navigationController pushViewController:customerVC animated:YES];
}


- (void)orderListBottomCellToLookExpress:(QGHOrderListBottomCell *)cell {
    NSString *encodedValue = [cell.item.posttype stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *webUrl = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@", encodedValue, cell.item.postid];
    AppWebViewController *webViewVC = [[AppWebViewController alloc] init];
    webViewVC.webUrl = webUrl;
    [self.navigationController pushViewController:webViewVC animated:YES];
}


- (void)orderListBottomCellToConfirmReceipt:(QGHOrderListBottomCell *)cell {
    [[MMHNetworkAdapter sharedAdapter] orderConfirmReceiptFrom:self order:cell.item.orderId succeededHandler:^{
        [self.view showTips:@"确认收货成功"];
        [self fetchData];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


- (void)orderListBottomCellToComment:(QGHOrderListBottomCell *)cell {
    QGHCommentViewController *commentVC = [[QGHCommentViewController alloc] initWithProduct:cell.item.goodlist.firstObject orderId:cell.item.orderId];
    [self.navigationController pushViewController:commentVC animated:YES];
}


- (void)orderListBottomCellToRefundAndGoods:(QGHOrderListBottomCell *)cell {
    [self.view showProcessingView];
    [[MMHNetworkAdapter sharedAdapter] refundOrderFrom:self orderId:cell.item.orderId succeededHandler:^{
        [self.view hideProcessingView];
        [self.view showTips:@"申请退款退货成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MMHChatCustomerViewController *customerVC = [[MMHChatCustomerViewController alloc] init];
            customerVC.transferOrderNo = cell.item.order_no;
            [self.navigationController pushViewController:customerVC animated:YES];
        });
    } failedHandler:^(NSError *error) {
        [self.view hideProcessingView];
        [self.view showTipsWithError:error];
    }];
}


- (void)orderListBottomCellToDeleteOrder:(QGHOrderListBottomCell *)cell {
    [[MMHNetworkAdapter sharedAdapter] cancelOrderFrom:self orderId:cell.item.orderId succeededHandler:^{
        [self.view showTips:@"删除订单成功"];
        [self fetchData];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


#pragma mark - QGHOrderDetailViewControllerDelegate


- (void)orderDetailViewControllerHandleOrder {
    [self fetchData];
    [self.navigationController popToViewController:self animated:YES];
}


@end

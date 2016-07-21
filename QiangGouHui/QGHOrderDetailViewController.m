//
//  QGHOrderDetailViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/25.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderDetailViewController.h"
#import "QGHOrderAddressCellTableViewCell.h"
#import "MMHOrderInfoTableViewCell.h"
#import "QGHOrderDetailProductCell.h"
#import "QGHOrderDetailCommonCell.h"
#import "MMHNetworkAdapter+Order.h"


static NSString *const QGHOrderDetailAddressCellIdentifier = @"QGHOrderDetailAddressCellIdentifier";
static NSString *const QGHOrderDetailProductCellIdentifier = @"QGHOrderDetailProductCellIdentifier";
static NSString *const QGHOrderDetailExpressCellIdentifier = @"QGHOrderDetailExpressCellIdentifier";
static NSString *const QGHOrderDetailPriceCellIdentifier = @"QGHOrderDetailPriceCellIdentifier";
static NSString *const QGHOrderDetailInfoCellIdentifier = @"QGHOrderDetailInfoCellIdentifier";


@interface QGHOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *productDataSource;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) QGHOrderInfo *orderInfo;

@end


@implementation QGHOrderDetailViewController


- (instancetype)initWithOrderId:(NSString *)orderId {
    self = [super init];
    
    if (self) {
        _orderId = orderId;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeTableView];
    [self makeBottomView];
    
    [self fetchData];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), mmh_screen_height() - 48 - 44) style:UITableViewStyleGrouped];
//    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"QGHOrderAddressCellTableViewCell" bundle:nil] forCellReuseIdentifier:QGHOrderDetailAddressCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHOrderDetailProductCell" bundle:nil] forCellReuseIdentifier:QGHOrderDetailProductCellIdentifier];
    [_tableView registerClass:[QGHOrderDetailCommonCell class] forCellReuseIdentifier:QGHOrderDetailExpressCellIdentifier];
    [_tableView registerClass:[MMHOrderInfoTableViewCell class] forCellReuseIdentifier:QGHOrderDetailInfoCellIdentifier];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}


- (void)makeBottomView {
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bottomView addTopSeparatorLine];
    
    _timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderDetails_icon_time"]];
    _timeImageView.x = 15;
    _timeImageView.centerY = 24;
    [_bottomView addSubview:_timeImageView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = F3;
    _timeLabel.textColor = C6;
    _timeLabel.centerY = _timeImageView.centerY;
    _timeLabel.x = _timeImageView.right + 10;
    [_bottomView addSubview:_timeLabel];
    
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mmh_screen_width());
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(0);
    }];
}


- (void)fetchData {
    [[MMHNetworkAdapter sharedAdapter] fetchOrderDetailFrom:self orderId:self.orderId succeededHandler:^(QGHOrderInfo *orderInfo) {
        self.orderInfo = orderInfo;
        self.title = [self getViewContollerTitle];
        [self.tableView reloadData];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.orderInfo.goodlist.count;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QGHOrderAddressCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderDetailAddressCellIdentifier forIndexPath:indexPath];
        cell.receiptAddressModel = self.orderInfo.receiptinfo;
        return cell;
    } else if (indexPath.section == 1) {
        QGHOrderDetailProductCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderDetailProductCellIdentifier forIndexPath:indexPath];
        cell.orderProduct = self.orderInfo.goodlist[indexPath.row];
        
        return cell;
    } else if (indexPath.section == 2) {
        QGHOrderDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderDetailExpressCellIdentifier forIndexPath:indexPath];
        if (self.orderInfo.posttype) {
            [cell setData:@[@{@"key": @"配送方式", @"value": self.orderInfo.posttype}]];
        }
        
        return cell;
    } else if (indexPath.section == 3) {
        QGHOrderDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderDetailExpressCellIdentifier forIndexPath:indexPath];
        NSString *productPrice = [NSString stringWithFormat:@"¥%g", self.orderInfo.amount];
        NSString *postPrice = [NSString stringWithFormat:@"¥%g", self.orderInfo.postage];
        [cell setData:@[@{@"key": @"商品金额", @"value": productPrice}, @{@"key": @"运费", @"value": postPrice}]];
        
        return cell;
    } else {
        MMHOrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderDetailInfoCellIdentifier forIndexPath:indexPath];
        cell.orderNumber = self.orderInfo.order_no;
        cell.orderingTime = self.orderInfo.create_time;
        switch (self.orderInfo.status) {
            case QGHOrderListItemStatusToPay:
                cell.orderState = @"待付款";
                break;
            case QGHOrderListItemStatusToExpress:
                cell.orderState = @"待发货";
                break;
            case QGHOrderListItemStatusToReceipt:
                cell.orderState = @"待收货";
                break;
            case QGHOrderListItemStatusToComment:
                cell.orderState = @"待评价";
                break;
            case QGHOrderListItemStatusFinish:
                cell.orderState = @"已完成";
                break;
            case QGHOrderListItemStatusCancel:
                cell.orderState = @"已取消";
                break;
            case QGHOrderListItemStatusRefund:
                cell.orderState = @"退款退货";
                break;
            default:
                break;
        }
        
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 1) {
        return 110;
    } else if (indexPath.section == 2) {
        return [QGHOrderDetailCommonCell heightWithData:@[@{@"key": @"配送方式", @"value": @"快递配送"}]];
    } else if (indexPath.section == 3) {
        return [QGHOrderDetailCommonCell heightWithData:@[@{@"key": @"商品金额", @"value": @"¥198"}, @{@"key": @"运费", @"value": @"¥10"}]];
    } else {
        return 100;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}


- (NSString *)getViewContollerTitle {
    switch (self.orderInfo.status) {
        case QGHOrderListItemStatusAll:
            return @"全部";
            break;
        case QGHOrderListItemStatusToPay:
            return @"待付款";
            break;
        case QGHOrderListItemStatusToExpress:
            return @"待发货";
            break;
        case QGHOrderListItemStatusToReceipt:
            return @"待收货";
            break;
        case QGHOrderListItemStatusToComment:
            return @"待评价";
            break;
        case QGHOrderListItemStatusFinish:
            return @"已完成";
            break;
        case QGHOrderListItemStatusCancel:
            return @"已取消";
            break;
        case QGHOrderListItemStatusRefund:
            return @"退款退货";
            break;
        default:
            return @"";
            break;
    }
}


@end

//
//  QGHConfirmOrderViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/2.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHConfirmOrderViewController.h"
#import "QGHOrderAddressCellTableViewCell.h"
#import "QGHOrderDetailProductCell.h"
#import "QGHOrderDetailCommonCell.h"
#import "MMHNetworkAdapter+ReceiptAddress.h"
#import "MMHNetworkAdapter+Order.h"
#import "QGHToSettlementModel.h"
#import "MMHWXPayHandle.h"


static NSString *const QGHConfirmOrderAddressCellIdentifier = @"QGHConfirmOrderAddressCellIdentifier";
static NSString *const QGHConfirmOrderProductCellIdentifier = @"QGHConfirmOrderProductCellIdentifier";
static NSString *const QGHConfirmOrderCommonCellIdentifier = @"QGHConfirmOrderCommonCellIdentifier";
//static NSString *const QGHConfirmOrderExpressCellIdentifier = @"QGHConfirmOrderExpressCellIdentifier";
//static NSString *const QGHConfirmOrderPriceCellIdentifier = @"QGHConfirmOrderPriceCellIdentifier";
//static NSString *const QGHConfirmOrderInfoCellIdentifier = @"QGHConfirmOrderInfoCellIdentifier";


@interface QGHConfirmOrderViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) QGHBussType bussType;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, assign) BOOL defaultReceiptStandBy;
@property (nonatomic, assign) BOOL mailPriceStandBy;

@property (nonatomic, strong) QGHReceiptAddressModel *defaultReceiptAddress;
@property (nonatomic, assign) float mailPrice;
@property (nonatomic, strong) NSMutableArray *productArr;

@property (nonatomic, strong) QGHProductDetailModel *productDetail;

@end

@implementation QGHConfirmOrderViewController


- (instancetype)initWithBussType:(QGHBussType)type productDetail:(QGHProductDetailModel *)detail {
    self = [super init];
    
    if (self) {
        _bussType = type;
        _productDetail = detail;
        _productArr = [NSMutableArray array];
        [_productArr addObject:detail];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
    switch (self.bussType) {
        case QGHBussTypeNormal:
        case QGHBussTypePurchase:
            _dataSource = @[@"地址", @"商品", @"配送方式", @"价格"];
            break;
        case QGHBussTypeAppoint:
            _dataSource = @[@"地址", @"商品", @"发货时间", @"配送方式", @"价格"];
            break;
        case QGHBussTypeCustom:
            _dataSource = @[@"地址", @"商品", @"生产周期", @"配送方式", @"价格"];
            break;
        default:
            break;
    }
    
    [self makeTableView];
    [self makeBottomView];
    
    [self fetchDefaultReceiptAddress];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"QGHOrderAddressCellTableViewCell" bundle:nil] forCellReuseIdentifier:QGHConfirmOrderAddressCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHOrderDetailProductCell" bundle:nil] forCellReuseIdentifier:QGHConfirmOrderProductCellIdentifier];
    [_tableView registerClass:[QGHOrderDetailCommonCell class] forCellReuseIdentifier:QGHConfirmOrderCommonCellIdentifier];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];
}


- (void)makeBottomView {
    _bottom = [[UIView alloc] init];
    _bottom.backgroundColor = [UIColor whiteColor];
    
    UILabel *sumLabel = [[UILabel alloc] init];
    sumLabel.font = F3;
    sumLabel.textColor = C8;
    sumLabel.text = @"合计：";
    [_bottom addSubview:sumLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont systemFontOfSize:22];
    _priceLabel.textColor = C8;
    _priceLabel.text = @"¥209";
    [_bottom addSubview:_priceLabel];
    
    UIButton *settleButton = [[UIButton alloc] init];
    settleButton.backgroundColor = C20;
    [settleButton setTitleColor:C21 forState:UIControlStateNormal];
    [settleButton setTitle:@"去结算" forState:UIControlStateNormal];
    settleButton.titleLabel.font = F6;
    [settleButton addTarget:self action:@selector(settleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottom addSubview:settleButton];
    
    [_bottom addTopSeparatorLine];
    [self.view addSubview:_bottom];
    
    [_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(mmh_screen_width());
        make.height.mas_equalTo(48);
    }];
    
    [sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(_bottom);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sumLabel.mas_right);
        make.centerY.equalTo(sumLabel.mas_centerY);
    }];
    
    [settleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(110);
        make.height.equalTo(_bottom);
        make.right.and.bottom.mas_equalTo(0);
    }];
}


- (void)fetchDefaultReceiptAddress {
    [self.view showProcessingView];
    
    [[MMHNetworkAdapter sharedAdapter] fetchDefaultReceiptAddressFrom:self succeededHandler:^(QGHReceiptAddressModel *address) {
        self.defaultReceiptAddress = address;
        self.defaultReceiptStandBy = YES;
        [self fetchMailPrice];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
        self.defaultReceiptStandBy = YES;
        [self tryToHideProcessingView];
    }];
}


- (void)fetchMailPrice {
    [[MMHNetworkAdapter sharedAdapter] fetchMailPriceFrom:self goodsId:self.productDetail.product.goodsId province:self.defaultReceiptAddress.province succeededHandler:^(float mainPrice) {
        self.mailPrice = mainPrice;
        self.mailPriceStandBy = YES;
        [self tryToHideProcessingView];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
        self.mailPriceStandBy = YES;
        [self tryToHideProcessingView];
    }];
}


- (void)tryToHideProcessingView {
    if (!self.defaultReceiptStandBy) {
        return;
    }
    if (!self.mailPriceStandBy) {
        return;
    }
    
    [self.view hideProcessingView];
    [self.tableView reloadData];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self nameForSection:section] isEqualToString:@"地址"]) {
        return 1;
    } else if ([[self nameForSection:section] isEqualToString:@"商品"]) {
        return self.productArr.count;
    } else if ([[self nameForSection:section] isEqualToString:@"配送方式"]) {
        return 1;
    } else if ([[self nameForSection:section] isEqualToString:@"发货时间"]) {
        return 1;
    } else if ([[self nameForSection:section] isEqualToString:@"生产周期"]) {
        return 1;
    } else if ([[self nameForSection:section] isEqualToString:@"价格"]) {
        return 1;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self nameForSection:indexPath.section] isEqualToString:@"地址"]) {
        QGHOrderAddressCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHConfirmOrderAddressCellIdentifier forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.receiptAddressModel = self.defaultReceiptAddress;
        
        return cell;
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"商品"]) {
        QGHOrderDetailProductCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHConfirmOrderProductCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setProductDetailModel:self.productDetail];
        
        return cell;
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"配送方式"]) {
        QGHOrderDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHConfirmOrderCommonCellIdentifier forIndexPath:indexPath];
        [cell setData:@[@{@"key": @"配送方式", @"value": @"快递配送"}]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"发货时间"]) {
        QGHOrderDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHConfirmOrderCommonCellIdentifier forIndexPath:indexPath];
        [cell setData:@[@{@"key": @"发货时间", @"value": @"6月10日"}]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"生产周期"]) {
        QGHOrderDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHConfirmOrderCommonCellIdentifier forIndexPath:indexPath];
        [cell setData:@[@{@"key": @"商品生产周期", @"value": @"15天"}]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"价格"]) {
        QGHOrderDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHConfirmOrderCommonCellIdentifier forIndexPath:indexPath];
        NSString *priceStr = [NSString stringWithFormat:@"¥%@", self.productDetail.product.min_price];
        NSString *mailPriceStr = [NSString stringWithFormat:@"¥%g", self.mailPrice];
        [cell setData:@[@{@"key": @"商品金额", @"value": priceStr}, @{@"key": @"运费", @"value": mailPriceStr}]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self nameForSection:indexPath.section] isEqualToString:@"地址"]) {
        return 70;
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"商品"]) {
        return 110;
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"配送方式"]) {
        return [QGHOrderDetailCommonCell heightWithData:@[@{@"key": @"配送方式", @"value": @"快递配送"}]];
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"发货时间"]) {
        return [QGHOrderDetailCommonCell heightWithData:@[@{@"key": @"发货时间", @"value": @"6月10日"}]];
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"生产周期"]) {
        return [QGHOrderDetailCommonCell heightWithData:@[@{@"key": @"商品生产周期", @"value": @"15天"}]];
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"价格"]) {
        return [QGHOrderDetailCommonCell heightWithData:@[@{@"key": @"商品金额", @"value": @"¥99"}, @{@"key": @"运费", @"value": @"¥10"}]];
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.00001;
    } else {
        return 10;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}


#pragma mark - Actions


- (void)settleButtonAction {
    QGHToSettlementModel *toSettlementModel = [[QGHToSettlementModel alloc] init];
    toSettlementModel.receiptId = self.defaultReceiptAddress.receiptAddressId;
    toSettlementModel.autoOrder = @"1";
    toSettlementModel.productArr = @[self.productDetail];
    toSettlementModel.amount = [self.productDetail.product.min_price floatValue];
//    toSettlementModel.delivery = 
    
    [[MMHNetworkAdapter sharedAdapter] sendRequestSettlementFrom:self parameters:[toSettlementModel parameters] succeededHandler:^(NSString *payId, NSString *orderNo) {
        
        [[MMHWXPayHandle wxPayHandle] sendPayWithOrder:orderNo];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


#pragma mark - private methods


- (NSString *)nameForSection:(NSInteger)section {
    return self.dataSource[section];
}


@end

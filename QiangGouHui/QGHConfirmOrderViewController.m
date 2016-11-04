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
#import "QGHReceiptAddressViewController.h"
#import "MMHPayWayViewController.h"
#import "QGHOrderListViewController.h"


static NSString *const QGHConfirmOrderAddressCellIdentifier = @"QGHConfirmOrderAddressCellIdentifier";
static NSString *const QGHConfirmOrderProductCellIdentifier = @"QGHConfirmOrderProductCellIdentifier";
static NSString *const QGHConfirmOrderCommonCellIdentifier = @"QGHConfirmOrderCommonCellIdentifier";
//static NSString *const QGHConfirmOrderExpressCellIdentifier = @"QGHConfirmOrderExpressCellIdentifier";
//static NSString *const QGHConfirmOrderPriceCellIdentifier = @"QGHConfirmOrderPriceCellIdentifier";
//static NSString *const QGHConfirmOrderInfoCellIdentifier = @"QGHConfirmOrderInfoCellIdentifier";


@interface QGHConfirmOrderViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, assign) QGHBussType bussType;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) BOOL defaultReceiptStandBy;
@property (nonatomic, assign) BOOL mailPriceStandBy;

@property (nonatomic, strong) QGHReceiptAddressModel *defaultReceiptAddress;
@property (nonatomic, assign) float mailPrice;
//@property (nonatomic, strong) NSMutableArray *productArr;

@property (nonatomic, strong) QGHProductDetailModel *productDetail;
@property (nonatomic, strong) NSArray<QGHCartItem *> *cartItemArr;

@end

@implementation QGHConfirmOrderViewController


- (instancetype)initWithBussType:(QGHBussType)type productDetail:(QGHProductDetailModel *)detail {
    self = [super init];
    
    if (self) {
        _bussType = type;
        _productDetail = detail;
//        _productArr = [NSMutableArray array];
//        [_productArr addObject:detail];
    }
    
    return self;
}


- (instancetype)initWithCartItemArr:(NSArray<QGHCartItem *> *)cartItemArr {
    self = [super init];
    
    if (self) {
        _cartItemArr = cartItemArr;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"QGHOrderAddressCellTableViewCell" bundle:nil] forCellReuseIdentifier:QGHConfirmOrderAddressCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHOrderDetailProductCell" bundle:nil] forCellReuseIdentifier:QGHConfirmOrderProductCellIdentifier];
    [_tableView registerClass:[QGHOrderDetailCommonCell class] forCellReuseIdentifier:QGHConfirmOrderCommonCellIdentifier];
    _tableView.tableFooterView = [self footerView];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];
}


- (UIView *)footerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 100)];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, mmh_screen_width() - 20, 80)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 4;
//    textView.placeholder = @"预约商品，海外直购需要提供客户身份信息，请输入身份证号码";
    textView.font = F3;
    textView.delegate = self;
    [view addSubview:textView];
    self.textView = textView;
    
    UILabel *placeholder = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, textView.width - 10, 0)];
    placeholder.numberOfLines = 0;
    placeholder.textColor = C6;
    placeholder.font = F3;
    placeholder.text = @"用户备注";
    [placeholder sizeToFit];
    [textView addSubview:placeholder];
    self.placeholderLabel = placeholder;
    
    return view;
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
    [settleButton setTitle:@"立即下单" forState:UIControlStateNormal];
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
    self.defaultReceiptStandBy = NO;
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
    NSString *goodsId = @"";
    self.mailPriceStandBy = NO;
    if (self.productDetail) {
        goodsId = self.productDetail.product.goodsId;
    } else {
        for (QGHCartItem *item in self.cartItemArr) {
            goodsId = [goodsId stringByAppendingString:item.good_id];
            goodsId = [goodsId stringByAppendingString:@","];
        }
        goodsId = [goodsId substringToIndex:goodsId.length - 1];
    }
    [[MMHNetworkAdapter sharedAdapter] fetchMailPriceFrom:self goodsId:goodsId province:self.defaultReceiptAddress.province succeededHandler:^(float mainPrice) {
        self.mailPrice = mainPrice;
        self.mailPriceStandBy = YES;
        
        float sumPrice = [[self getSumPrice] floatValue] + self.mailPrice;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%g", sumPrice];
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
        if (self.productDetail) {
            return 1;
        } else {
            return self.cartItemArr.count;
        }
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
        if (self.productDetail) {
            [cell setProductDetailModel:self.productDetail];
        } else {
            QGHCartItem *cartItem = self.cartItemArr[indexPath.row];
            [cell setCartItem:cartItem];
        }
        
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
//        NSString *priceStr = [NSString stringWithFormat:@"¥%@", self.productDetail.product.min_price];
        NSString *mailPriceStr = [NSString stringWithFormat:@"¥%g", self.mailPrice];
        [cell setData:@[@{@"key": @"商品金额", @"value": [self getSumPrice]}, @{@"key": @"运费", @"value": mailPriceStr}]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QGHReceiptAddressViewController *receiptAddressVC = [[QGHReceiptAddressViewController alloc] init];
        receiptAddressVC.selectAddressBlock = ^(QGHReceiptAddressModel *address) {
            self.defaultReceiptAddress = address;
            [self.view showProcessingView];
            [self fetchMailPrice];
            [self.navigationController popToViewController:self animated:YES];
        };
        [self.navigationController pushViewController:receiptAddressVC animated:YES];
    }
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
}


#pragma mark - UITextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}


#pragma mark - Actions


- (void)settleButtonAction {
    if (self.defaultReceiptAddress.receiptAddressId.length == 0) {
        [self.view showTips:@"请选择收货地址"];
        return;
    }
    
    QGHToSettlementModel *toSettlementModel = [[QGHToSettlementModel alloc] init];
    toSettlementModel.bussType = self.bussType;
    toSettlementModel.receiptId = self.defaultReceiptAddress.receiptAddressId;
    toSettlementModel.mailPrice = self.mailPrice;
    toSettlementModel.note = self.textView.text;
    if (self.productDetail) {
        toSettlementModel.autoOrder = @"1";
    }
    
    if ([toSettlementModel.autoOrder isEqualToString:@"1"]) {
        if (toSettlementModel.bussType == QGHBussTypeNormal || toSettlementModel.bussType == QGHBussTypePurchase) {
            toSettlementModel.productArr = @[self.productDetail];
        } else if (toSettlementModel.bussType == QGHBussTypeAppoint) {
            toSettlementModel.delivery = self.productDetail.product.appointment;
        } else if (toSettlementModel.bussType == QGHBussTypePurchase) {
            toSettlementModel.production_time = self.productDetail.product.production_time;
        }
    } else {
        NSString *cardIds = @"";
        for (QGHCartItem *item in self.cartItemArr) {
            cardIds = [cardIds stringByAppendingString:item.itemId];
            cardIds = [cardIds stringByAppendingString:@","];
        }
        cardIds = [cardIds substringToIndex:cardIds.length - 1];
        toSettlementModel.cartItemIds = cardIds;
    }
    
    toSettlementModel.amount = [[self getSumPrice] floatValue];

    __weak typeof(self) weakSelf = self;
    [[MMHNetworkAdapter sharedAdapter] sendRequestSettlementFrom:self parameters:[toSettlementModel parameters] succeededHandler:^(NSString *payId, NSString *orderNo) {
        MMHPayWayViewController *payWayVC = [[MMHPayWayViewController alloc] initWithPayPrice:[[weakSelf getSumPrice] floatValue] + self.mailPrice orderNo:orderNo payWay:^(MMHPayWay payWay) {
            NSString *payPrice = [NSString stringWithFormat:@"%g", [[weakSelf getSumPrice] floatValue] + self.mailPrice];
            [[MMHPayManager sharedInstance] goToPayManager:orderNo price:payPrice productTitle:[self getProductTitle] payWay:payWay invoker:weakSelf successHandler:^{
                [self goToOrderList];
            } failHandler:^(NSString *error) {
                [self.view showTips:error];
                [self goToOrderList];
            }];
        }];
        [weakSelf.navigationController pushViewController:payWayVC animated:YES];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
//    CGFloat keyboardTop = keyboardRect.origin.y;
    //    CGRect newTextViewFrame = self.suggestedKeywordsView.frame;
    //    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.intValue];
    
    [self.tableView setMaxY:self.view.bounds.size.height - keyboardRect.size.height];
    
    [UIView commitAnimations];
    
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.height) animated:NO];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.intValue];
    
    [self.tableView setMaxY:self.view.bounds.size.height - 48];
    
    [UIView commitAnimations];
}

#pragma mark - private methods


- (void)goToOrderList {
    QGHOrderListViewController *listVC = [[QGHOrderListViewController alloc] init];
    [QGHTabBarController redirectToCenterWithController:listVC];
}


- (NSString *)nameForSection:(NSInteger)section {
    return self.dataSource[section];
}
//
//
- (NSString *)getSumPrice {
    if (self.productDetail) {
//        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", self.productDetail.product.min_price];
        float sumPrice = 0;
        if (self.productDetail.skuSelectModel.selectedSKUIds.count > 0) {
            sumPrice += [[self.productDetail allSepcSelectedPrice].discount_price floatValue] * self.productDetail.skuSelectModel.count;
            return [NSString stringWithFormat:@"%g", sumPrice];
        } else {
            sumPrice = [self.productDetail.product.discount_price floatValue] * self.productDetail.skuSelectModel.count;
            return [NSString stringWithFormat:@"%g", sumPrice];
        }
        
    } else {
        float sumPrice = 0;
        for (QGHCartItem *item in self.cartItemArr) {
            sumPrice += item.min_price * item.count;
        }
//        self.priceLabel.text = [NSString stringWithFormat:@"¥%g", sumPrice];
        return [NSString stringWithFormat:@"%g", sumPrice];
    }

}

- (NSString *)getProductTitle {
    if (self.productDetail) {
        return self.productDetail.product.title;
    } else if (self.cartItemArr.count > 0) {
        __block NSString *productTitles = @"";
        [self.cartItemArr enumerateObjectsUsingBlock:^(QGHCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            productTitles = [productTitles stringByAppendingString:obj.title];
            if (idx != self.cartItemArr.count - 1) {
                productTitles = [productTitles stringByAppendingString:@"|"];
            }
        }];
        
        return productTitles;
    }
    
    return @"";
}

@end

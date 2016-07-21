//
//  MMHPayWayViewController.m
//  MamHao
//
//  Created by YaoChi on 15/8/11.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHPayWayViewController.h"
#import "MMHWeChatAdapter.h"

#import "MMHNetworkAdapter+Order.h"

static NSString *const MMHPayWayPriceCellIdentifier = @"priceCellIdentifier";
static NSString *const MMHPayWayCellIdentifier = @"payWayCellIdentifier";


@interface MMHPayWayViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString *orderNo;

@property (nonatomic, copy) SelectPayWay selectPayWay;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *payWayIconArr;
@property (nonatomic, strong) NSArray *payWayNameArr;

@end


@implementation MMHPayWayViewController


- (instancetype)initWithPayPrice:(float)price orderNo:(NSString *)orderNo payWay:(SelectPayWay)payWay {
    self = [super init];
    if (self) {
        self.title = @"确认订单";
        self.price = price;
        self.orderNo = orderNo;
        self.selectPayWay = payWay;
        self.payWayIconArr = @[@"order_img_zhifubao", @"order_img_weixin"];
        self.payWayNameArr = @[@"支付宝支付", @"微信支付"];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.payWayIconArr.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MMHPayWayPriceCellIdentifier];
            if (!cell) {
                cell = [self createPriceCell];
            }
            
            return cell;
        }
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MMHPayWayCellIdentifier];
            if (!cell) {
                cell = [self createPayWayCell];
            }
            [self payWayCellLayout:cell forIndexPath:indexPath];
            
            return cell;
        }
        default:
            return nil;
    }
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMHPayWay payWay = -1;
    
    switch (indexPath.row) {
        case 0:
            payWay = MMHPayWayAlipay;
            self.selectPayWay(payWay);
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            if (![MMHWeChatAdapter isWeChatInstalled]) {
                AppAlertViewController *alert = [[AppAlertViewController alloc] initWithParentController:self];
                [alert showAlert:@"提示" message:@"系统检测到您的手机没有安装微信，您还可以选择其他方式" sureTitle:nil cancelTitle:@"OK" sure:nil cancel:nil];
            }else{
                payWay = MMHPayWayWeixin;
                self.selectPayWay(payWay);
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 44;
        case 1:
            return 50;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 10;
        case 1:
            return 5;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
        case 1:
            return 10;
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

#pragma mark - Private methods
- (UITableViewCell *)createPriceCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMHPayWayPriceCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor colorWithHexString:@"999999"];
    title.font = F5;
    [title setSingleLineText:@"请支付"];
    [title setX:10];
    [title setCenterY:22];
    [cell.contentView addSubview:title];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = C22;
    priceLabel.font = [UIFont boldSystemFontOfSize:15];
    [priceLabel setSingleLineText:[NSString stringWithFormat:@"￥%g", self.price]];
    [priceLabel setRight:kScreenWidth - 10];
    [priceLabel setCenterY:22];
    [cell.contentView addSubview:priceLabel];
    
    return cell;
}

- (UITableViewCell *)createPayWayCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMHPayWayCellIdentifier];
    
    UIImageView *payWayIcon = [[UIImageView alloc] init];
    payWayIcon.tag = 200;
    [cell.contentView addSubview:payWayIcon];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor colorWithHexString:@"333333"];
    title.font = F5;
    title.tag = 201;
    [cell.contentView addSubview:title];
    
    UIImageView *disclosureIndicatiorImg = [UIImageView imageViewWithImageName:@"shared_disclosureIndicator"];
    disclosureIndicatiorImg.tag = 202;
    [cell.contentView addSubview:disclosureIndicatiorImg];
    
    return cell;
}

- (void)payWayCellLayout:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    UIImageView *icon = (UIImageView *)[cell viewWithTag:200];
    icon.image = [UIImage imageNamed:self.payWayIconArr[indexPath.row]];
    [icon sizeToFit];
    if ([self.payWayNameArr[indexPath.row] isEqualToString:@"银联支付"]) {
        [icon setX:8];
    } else {
        [icon setX:10];
    }
    [icon setCenterY:25];
    
    UILabel *title = (UILabel *)[cell viewWithTag:201];
    [title setSingleLineText:self.payWayNameArr[indexPath.row]];
    if ([self.payWayNameArr[indexPath.row] isEqualToString:@"银联支付"]) {
        [title attachToRightSideOfView:icon byDistance:8];
    } else {
        [title attachToRightSideOfView:icon byDistance:10];
    }
    [title setCenterY:icon.centerY];
    
    UIImageView *disclosureIndicatorImg = (UIImageView *)[cell viewWithTag:202];
    [disclosureIndicatorImg setCenterY:icon.centerY];
    [disclosureIndicatorImg moveToRight:kScreenWidth - 10];
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [QGHAppearance separatorColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
    return _tableView;
}

@end

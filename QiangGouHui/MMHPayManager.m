//
//  MMHPayManager.m
//  MamHao
//
//  Created by fishycx on 15/11/17.
//  Copyright © 2015年 Mamahao. All rights reserved.
//

#import "MMHPayManager.h"
#import "MMHWXPayHandle.h"
#import "MMHAliPayHandle.h"
#import "MMHNetworkAdapter+Order.h"


@interface MMHPayManager ()

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) UIViewController *invoker;
@property (nonatomic, copy) MMHPayFailHandler failHandler;
@property (nonatomic, copy) MMHPaySuccessHandler successHandler;

@end


@implementation MMHPayManager


+ (instancetype)sharedInstance{
    static MMHPayManager *payManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payManager = [[MMHPayManager alloc] init];
    });
    return payManager;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayNotification:) name:MMHAlipayNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayFinished:) name:MMHWeChatPayFinishedNotification object:nil];
    }
    return self;
}


- (void)goToPayManager:(NSString *)orderNo price:(NSString *)price productTitle:(NSString *)title payWay:(MMHPayWay)payWay invoker:(UIViewController *)controller successHandler:(MMHPaySuccessHandler)successHandler failHandler:(MMHPayFailHandler)failHandler {
    self.invoker = controller;
    self.orderNo = orderNo;
    self.successHandler = successHandler;
    self.failHandler = failHandler;
    switch (payWay) {
        case MMHPayWayAlipay:
            //支付宝支付
            [self weakUpAliPayWithPrice:price orderNo:orderNo productName:title];
            break;
        case MMHPayWayWeixin:
            //微信支付
            [[MMHWXPayHandle wxPayHandle] sendPayWithOrder:self.orderNo];
            
            break;
        default:
            break;
    }

}


/**
 *  支付成功锁订单
 *
 *  @param orderNo 订单号
 *  @param payWay  支付方式：银联 支付宝 微信
 */
//- (void)lockOrderWithOrderNo:(NSString *)orderNo Type:(NSInteger)payWay succeddHandler:(void(^)())succeedHandler failedHandler:(MMHNetworkFailedHandler)faileHandler{
//    BOOL isPayForVip;
//    if (self.payType == MMHPayTypeForVIP) {
//        isPayForVip = YES;
//    } else {
//        isPayForVip = NO;
//    }
//    [[MMHNetworkAdapter sharedAdapter] lockOrder:orderNo orderPayType:payWay isPayForVip:isPayForVip from:nil succeededHandler:^{
//        succeedHandler();
//    } failedHandler:^(NSError *error) {
//        faileHandler(error);
//    }];
//    
//}



#pragma mark 唤起支付宝进行支付


-(void)weakUpAliPayWithPrice:(NSString *)price orderNo:(NSString *)orderNo productName:(NSString *)productName {
    MMHPayOrderModel *payOrderModel = [[MMHPayOrderModel alloc]init];
    payOrderModel.amount = price;
    payOrderModel.tradeNO = orderNo;
    payOrderModel.productName = productName;
    [MMHAliPayHandle goPayWithOrder:payOrderModel];
}


//微信支付通知
- (void)weChatPayFinished:(NSNotification *)notification {
    BaseResp *resp = notification.userInfo[MMHWeChatPayResponseKey];
    NSString *error = nil;
    switch ([resp errCode]) {
        case WXSuccess:{
            [[MMHNetworkAdapter sharedAdapter] paySuccessCallBack:self.orderNo];
            self.successHandler();
        }
            break;
        case WXErrCodeCommon:{
            /**< 普通错误类型    */
            error = @"订单支付失败";
            
        }
            break;
        case WXErrCodeUserCancel:{
            /**< 用户点击取消并返回    */
            error = @"用户中途取消";
        }
            break;
        case WXErrCodeSentFail:{
            /**< 发送失败    */
            error = @"订单支付失败";
        }
            break;
        case WXErrCodeAuthDeny:{
            /**< 授权失败    */
            error = @"订单支付失败";
        }
            break;
        case WXErrCodeUnsupport:{
            /**< 微信不支持    */
            error = @"微信不支持";
        }
            break;
        default:
            break;
    }
    if (error.length > 0) {
        self.failHandler(error);
    }
}


#pragma mark 支付宝支付通知


-(void)aliPayNotification:(NSNotification *)note{
    NSString *resultOrderNo = [note.userInfo objectForKey:@"resultOrderNo"];
    if ([resultOrderNo isEqualToString:[MMHAliPayHandle alipayOrderNoShared].alipayOutTradeNo]){
        return;
    }
    
    if(resultOrderNo.length != 0) {
        [MMHAliPayHandle alipayOrderNoShared].alipayOutTradeNo = resultOrderNo;
    }
    
    NSString *payNotificationState = [note.userInfo objectForKey:@"resultStatus"];
    NSString *error;
    if([payNotificationState integerValue] == 6001){            // 【用户中途取消】
        error = @"用户中途取消";
    } else if ([payNotificationState integerValue] == 6002){    // 【网络连接出错】
        error = @"网络连接出错";
    } else if ([payNotificationState integerValue] == 4000){    // 【订单支付失败】
        error = @"订单支付失败";
    } else if ([payNotificationState integerValue] == 8000){     // 【订单正在处理中]
        error = @"订单正在处理中";
    } else if ([payNotificationState integerValue] == 9000){     // 【订单支付成功】
        self.successHandler();
    }
    if (error.length > 0) {
        self.failHandler(error);
    }
}


@end

//
//  MMHNetworkAdapter+Order.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "QGHWeChatPrePayModel.h"

@interface MMHNetworkAdapter (Order)

- (void)fetchMailPriceFrom:(id)requester goodsId:(NSString *)goodsId province:(NSString *)province succeededHandler:(void (^)(float mailPrice))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)sendRequestSettlementFrom:(id)requester parameters:(NSDictionary *)parameters succeededHandler:(void (^)(NSString *payId, NSString *orderNo))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)sendRequestWechatPayDataFrom:(id)requester orderNo:(NSString *)orderNo succeededHandler:(void (^)(QGHWeChatPrePayModel *prePayModel))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

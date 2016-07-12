//
//  MMHNetworkAdapter+Order.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+Order.h"


@implementation MMHNetworkAdapter (Order)


- (void)fetchMailPriceFrom:(id)requester goodsId:(NSString *)goodsId province:(NSString *)province succeededHandler:(void (^)(float mailPrice))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSMutableDictionary *parameters = [@{@"userToken": [[MMHAccountSession currentSession] token], @"goodid": goodsId} mutableCopy];
    if (province.length > 0) {
        [parameters addEntriesFromDictionary:@{@"province": province}];
    }
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_postage_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSDictionary *dict = [responseJSONObject objectForKey:@"info"];
        succeededHandler([dict[@"postage"] floatValue]);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)sendRequestSettlementFrom:(id)requester parameters:(NSDictionary *)parameters succeededHandler:(void (^)(NSString *payId, NSString *orderNo))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_order_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSDictionary *infoDict = responseJSONObject[@"info"];
        succeededHandler(infoDict[@"id"], infoDict[@"order_no"]);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)sendRequestWechatPayDataFrom:(id)requester orderNo:(NSString *)orderNo succeededHandler:(void (^)(QGHWeChatPrePayModel *prePayModel))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token], @"order_id": orderNo};
    [engine postWithAPI:@"_wechat_pay_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        QGHWeChatPrePayModel *prePayModel = [[QGHWeChatPrePayModel alloc] initWithJSONDict:responseJSONObject[@"info"]];
        succeededHandler(prePayModel);

    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

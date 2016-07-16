//
//  MMHNetworkAdapter+Cart.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/6.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+Cart.h"

@implementation MMHNetworkAdapter (Cart)


- (void)fetchCartListFrom:(id)requester succeededHandler:(void(^)(NSArray<QGHCartItem *> *itemArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_card_list_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSArray *itemArr = [[responseJSONObject objectForKey:@"info"] modelArrayOfClass:[QGHCartItem class]];
        succeededHandler(itemArr);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)addCartFrom:(id)requester goodsId:(NSString *)goodsId count:(NSInteger)count price:(NSString *)price skuId:(NSString *)skuId succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSMutableDictionary *parameters = [@{@"userToken": [[MMHAccountSession currentSession] token], @"good_id": goodsId, @"count": @(count), @"price": price} mutableCopy];
    if (skuId) {
        [parameters addEntriesFromDictionary:@{@"sku_id": skuId}];
    }
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_set_crad_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)modifyCartCountFrom:(id)requester goodsId:(NSString *)goodsId count:(NSInteger)count price:(NSString *)price itemId:(NSString *)itemId succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token], @"good_id": goodsId, @"count": @(count), @"price": price, @"id": itemId};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_set_crad_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)deleteCartItemFrom:(id)requester itemId:(NSString *)itemId succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token], @"id": itemId};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_delete_crad_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}

@end

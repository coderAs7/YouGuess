//
//  MMHNetworkAdapter+ReceiptAddress.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/9.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+ReceiptAddress.h"


@implementation MMHNetworkAdapter (ReceiptAddress)


- (void)fetchReceiptAddressListFrom:(id)requester succeededHandler:(void (^)(NSArray<QGHReceiptAddressModel *> *receiptAddressArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_receipt_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSArray *receiptArr = [[responseJSONObject objectForKey:@"info"] modelArrayOfClass:[QGHReceiptAddressModel class]];
        succeededHandler(receiptArr);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)fetchDefaultReceiptAddressFrom:(id)requester succeededHandler:(void (^)(QGHReceiptAddressModel *address))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_default_receipt_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        QGHReceiptAddressModel *model = [[QGHReceiptAddressModel alloc] initWithJSONDict:[responseJSONObject objectForKey:@"info"]];
        succeededHandler(model);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)setDefaultReceiptAddressFrom:(id)requester addressId:(NSString *)addressId succeededHandler:(void (^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token], @"id": addressId};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_change_default_receipt_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)deleteReceiptAddressFrom:(id)requester addressId:(NSString *)addressId succeededHandler:(void (^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token], @"id": addressId};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_delete_receipt_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)addOrModifyAddressFrom:(id)requester deliveryId:(NSString *)deliveryId addAddressModel:(QGHReceiptAddressModel *)model succeededHandler:(void (^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    
    NSMutableDictionary *parameters = [@{@"userToken": [[MMHAccountSession currentSession] token], @"province": [model.province clearSheng], @"city": [model.city clearShi], @"area": [model.area clearQu], @"address": model.address, @"phone": model.phone, @"username": model.username, @"isdefault": model.isdefault} mutableCopy];
    if (deliveryId) {
        [parameters addEntriesFromDictionary:@{@"id": deliveryId}];
    }
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_set_receipt_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

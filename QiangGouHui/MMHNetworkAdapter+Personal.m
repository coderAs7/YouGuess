//
//  MMHNetworkAdapter+Personal.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/22.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+Personal.h"

@implementation MMHNetworkAdapter (Personal)

- (void)fetchOrderNumFrom:(id)requester succeededHandler:(void(^)(QGHOrderNumModel *orderNum))  succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_ordernum_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        QGHOrderNumModel *orderNum = [[QGHOrderNumModel alloc] initWithJSONDict:responseJSONObject[@"info"]];
        succeededHandler(orderNum);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)sendSuggestionFrom:(id)requester content:(NSString *)content succeededHandler:(void(^)())succeededHandler failHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token], @"content": content, @"contactInfo": @""};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_beedback_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)fetchAboutUsFrom:(id)requester succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_help_002" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

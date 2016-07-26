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


- (void)uploadHeaderImageFrom:(id)requester image:(UIImage *)image succeededHandler:(void(^)(NSString *urlString))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_upload_001" parameters:parameters image:image from:requester succeededBlock:^(id responseObject, id responseJSONObject) {
        NSString *urlString = responseJSONObject[@"info"][@"url"];
        succeededHandler(urlString);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)savePersonalInfoFrom:(id)requester personalInfo:(QGHPersonalInfo *)personalInfo succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token], @"sex": personalInfo.sex, @"nickname": personalInfo.nickName, @"liveAddress": personalInfo.liveAddress};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_update_userinfo_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

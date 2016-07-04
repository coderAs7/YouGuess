//
//  MMHNetworkAdapter+Login.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+Login.h"
#import "MMHAccount.h"
#import "MMHAccountSession.h"

@implementation MMHNetworkAdapter (Login)


- (void)loginWithPhoneNumber:(NSString *)phoneNumber passCode:(NSString *)passCode from:(id)requester succeededHandler:(void(^)(MMHAccount *account))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"username": phoneNumber, @"loginPass": passCode};
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_login_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        MMHAccount *account = [[MMHAccount alloc] initWithJSONDict:[responseJSONObject objectForKey:@"info"]];
        [[MMHAccountSession currentSession] accountDidLogin:account];
        [[NSNotificationCenter defaultCenter] postNotificationName:MMHUserDidLoginNotification object:nil];
        succeededHandler(account);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

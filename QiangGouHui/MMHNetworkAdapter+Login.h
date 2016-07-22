//
//  MMHNetworkAdapter+Login.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"

@class MMHAccount;

@interface MMHNetworkAdapter (Login)

- (void)loginWithPhoneNumber:(NSString *)phoneNumber passCode:(NSString *)passCode from:(id)requester succeededHandler:(void(^)(MMHAccount *account))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)logoutWithRequester:(id)requester succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

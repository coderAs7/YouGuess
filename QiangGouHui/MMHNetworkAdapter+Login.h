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

- (void)resetPasswordFrom:(id)requester phone:(NSString *)phone pwd:(NSString *)pwd verifyCode:(NSString *)verifyCode succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)registerFrom:(id)requester loginType:(QGHLoginType)type phone:(NSString *)phone pwd:(NSString *)pwd verifyCode:(NSString *)verifyCode thirdId:(NSString *)thirdId thirdToken:(NSString *)thirdToken succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

//
//  MMHNetworkAdapter+Personal.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/22.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "QGHOrderNumModel.h"
#import "QGHPersonalInfo.h"

@interface MMHNetworkAdapter (Personal)

- (void)fetchOrderNumFrom:(id)requester succeededHandler:(void(^)(QGHOrderNumModel *orderNum))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)sendSuggestionFrom:(id)requester content:(NSString *)content succeededHandler:(void(^)())succeededHandler failHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)fetchAboutUsFrom:(id)requester succeededHandler:(void(^)(NSString *aboutUsStr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)uploadHeaderImageFrom:(id)requester image:(UIImage *)image succeededHandler:(void(^)(NSString *urlString))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)savePersonalInfoFrom:(id)requester personalInfo:(QGHPersonalInfo *)personalInfo succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)checkVersion:(id)requester succeededHandler:(void(^)(NSString *version))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

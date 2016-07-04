//
//  MMHNetworkEngine.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "AFHTTPSessionManager.h"


typedef void(^MMHNetworkFailedHandler)(NSError *error);


@interface MMHNetworkEngine : AFHTTPSessionManager

+ (MMHNetworkEngine *)sharedEngine;

- (instancetype)initWithHost:(NSString *)host;
- (instancetype)initWithHost:(NSString *)host port:(NSString *)port;

- (void)postWithAPI:(NSString *)api parameters:(NSDictionary *)parameters from:(id)requester responseObjectClass:(Class)responseObjectClass responseObjectKeyMap:(NSDictionary *)responseObjectKeyMap succeededBlock:(void (^)(id responseObject, id responseJSONObject))succeededBlock failedBlock:(MMHNetworkFailedHandler)failedBlock;

@end


@interface MMHNetworkEngine (ApplicationSession)

+ (NSString *)currentServerAddress;

@end

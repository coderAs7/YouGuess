//
//  MMHNetworkEngine.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHNetworkEngine.h"
#import "MMHRequestSerializer.h"
#import "MMHResponseSerializer.h"
#import "MMHNetworkAdapter.h"
#import "MMHFetchModel.h"
//#import "MMHTimestamp.h"
//#import "MMHAccountSession.h"
//#import "MMHSwift.h"


@implementation MMHNetworkEngine


+ (MMHNetworkEngine *)sharedEngine {
    static MMHNetworkEngine *_sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//#if defined (API_MAMAHAO_COM)
//        NSString *baseURLString = @"http://121.14.38.35/index.php";
//        baseURLString = [ApplicationSession reconfigureBaseURLString:baseURLString];
//        _sharedEngine = [[MMHNetworkEngine alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
        _sharedEngine = [[MMHNetworkEngine alloc] init];
//#if 0
//        NSDictionary *parameters = [[NSUserDefaults standardUserDefaults] objectForKey:MMHUserDefaultsKeyServerAddress];
//        if ([parameters hasKey:@"server"]) {
//            NSString *server = [parameters stringForKey:@"server"];
//            if (![server isEqualToString:@"standard"]) {
//                if ([server rangeOfString:@"."].location == NSNotFound) {
//                    server = [NSString stringWithFormat:@"192.168.1.%@", server];
//                }
//                NSString *port = [parameters stringForKey:@"port"];
//                if (port.length == 0) {
//                    port = @"8080";
//                }
//                _sharedEngine = [[MMHNetworkEngine alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/gd-app-api", server, port]]];
//            }
//            else {
//                _sharedEngine = [[MMHNetworkEngine alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.mamhao.cn:80"]];
//            }
//        }
//#endif
        _sharedEngine.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedEngine.requestSerializer = [[MMHRequestSerializer alloc] init];
        _sharedEngine.requestSerializer.timeoutInterval = 10.0;
        _sharedEngine.responseSerializer = [[MMHResponseSerializer alloc] init];
        _sharedEngine.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    });
    
    return _sharedEngine;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDataTaskWillCacheResponseBlock:^NSCachedURLResponse *(NSURLSession *session, NSURLSessionDataTask *dataTask, NSCachedURLResponse *proposedResponse) {
            NSCachedURLResponse *newCachedResponse = [[NSCachedURLResponse alloc]
                                                      initWithResponse:[proposedResponse response]
                                                      data:[proposedResponse data]
                                                      userInfo:nil
                                                      storagePolicy:NSURLCacheStorageAllowedInMemoryOnly];
            return newCachedResponse;
        }];
    }
    return self;
}


//- (instancetype)initWithHost:(NSString *)host
//{
//    return [self initWithHost:host port:@"8080"];
//}
//
//
//- (instancetype)initWithHost:(NSString *)host port:(NSString *)port
//{
//    self = [self initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/gd-app-api", host, port]]];
//    if (self) {
//        self.requestSerializer = [[MMHRequestSerializer alloc] init];
//        self.requestSerializer.timeoutInterval = 10.0;
//        self.responseSerializer = [[MMHResponseSerializer alloc] init];
//    }
//    return self;
//}


- (void)postWithAPI:(NSString *)api parameters:(NSDictionary *)parameters from:(id)requester responseObjectClass:(Class)responseObjectClass responseObjectKeyMap:(NSDictionary *)responseObjectKeyMap succeededBlock:(void (^)(id responseObject, id responseJSONObject))succeededBlock failedBlock:(MMHNetworkFailedHandler)failedBlock {
    //    NSString *timeIntervalString = [MMHTimestamp timestampString];
//    NSMutableDictionary *actualParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    //    actualParameters[@"ts"] = timeIntervalString;
    
//    if (![[parameters allKeys] containsObject:@"memberId"]) {
//        if (![api hasSuffix:@"login.htm"]) {
//            //            NSString *memberID = [[MMHAccountSession currentSession] memberID];
//            //            if (memberID.length != 0) {
//            //                actualParameters[@"memberId"] = memberID;
//            //            }
//        }
//    }
    //    LZLog(@"post with api: %@", actualAPI);
    //    LZLog(@"post with parameters: %@", actualParameters);
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    [mutableParameters addEntriesFromDictionary:@{@"apiCode": api}];
    NSString *parametersJsonStr = [self parametersString:mutableParameters];
    NSDictionary *actualParameter = @{@"json": parametersJsonStr};
    
    [self POST:@"http://121.14.38.35/index.php" parameters:actualParameter
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSLog(@"===+++post with api: %@", api);
           NSLog(@"===+++post with parameters: %@", actualParameter);
           NSLog(@"got response object: %@", responseObject);
           if (responseObject == nil) {
               //               NSError *error = [NSError errorWithDomain:MMHErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: @"未知错误"}];
               //               failedBlock(error);
           }
           if ([responseObject isKindOfClass:[NSDictionary class]]) {
               NSArray *allKeys = [responseObject allKeys];
               if ([allKeys containsObject:@"error"] && [allKeys containsObject:@"error_code"]) {
                   NSError *error = [NSError errorWithDomain:@"MMHErrorDomain"
                                                        code:[responseObject[@"error_code"] integerValue]
                                                    userInfo:@{NSLocalizedDescriptionKey: responseObject[@"error"]}];
                   NSLog(@"got error: %@, request is: %@, parameters: %@", error, task.currentRequest, actualParameter);
                   //                   [MMHLogbook logErrorWithEventName:api error:error];
                   failedBlock(error);
                   return ;
               }
           }
           
           if (responseObjectClass == nil) {
               succeededBlock(nil, responseObject);
               return;
           }
           if (![responseObjectClass isSubclassOfClass:[MMHFetchModel class]]) {
               succeededBlock(nil, responseObject);
               return;
           }
           if ([responseObjectClass instancesRespondToSelector:@selector(initWithJSONDict:keyMap:)]) {
               MMHFetchModel *responseModelObject = (MMHFetchModel *)[[responseObjectClass alloc] initWithJSONDict:responseObject keyMap:responseObjectKeyMap];
               if (responseModelObject) {
                   succeededBlock(responseModelObject, responseObject);
                   return;
               }
           }
           //        NSError *error = [[NSError alloc] initWithDomain:MMHErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"未知错误"}];
           //        failedBlock(error);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"got error: %@, request is: %@, parameters: %@", error, task.currentRequest, actualParameter);
           //        [MMHLogbook logErrorWithEventName:api error:error];
           if (failedBlock){
               failedBlock(error);
           }
       }];

}


- (NSString *)parametersString:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    [mutableParameters removeObjectForKey:@"apiCode"];
    NSArray *keys = [mutableParameters allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *key1 = (NSString *)obj1;
        NSString *key2 = (NSString *)obj2;
        return [key1 compare:key2];
    }];
    
    NSString *token = parameters[@"apiCode"];
    for (NSString *key in sortedKeys) {
        NSString *value = [NSString stringWithFormat:@"%@", parameters[key]];
        token = [token stringByAppendingString:value];
    }
    token = [token stringByAppendingString:@"32a0357b12de425b9b957b25f66cf002"];
    token = [token md5String];
    

    [mutableParameters addEntriesFromDictionary:@{@"apiCode": parameters[@"apiCode"], @"token": token}];
    return [mutableParameters mmh_JSONString];
}

@end


@implementation MMHNetworkEngine (ApplicationSession)


+ (NSString *)currentServerAddress {
    MMHNetworkEngine *engine = [self sharedEngine];
    return [engine.baseURL absoluteString];
}


@end

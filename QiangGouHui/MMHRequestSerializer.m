//
//  MMHRequestSerializer.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHRequestSerializer.h"
//#import "MMHAccountSession.h"
//#import "MMHAccount.h"


@implementation MMHRequestSerializer


- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifiction:) name:MMHUserDidLogoutNotification object:nil];
    }
    return self;
}

- (void)handleNotifiction:(NSNotification *)sender{
    self.temporaryAccount = nil;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *request = [super requestWithMethod:method
                                                  URLString:URLString
                                                 parameters:parameters
                                                      error:error];
    if (!(*error)) {
        if ([parameters count] != 0) {
            NSString *appId = @"10001";
            NSString *secret = @"d41d8cd98f00b204e9800998ecf8427e";
            NSArray *allKeys = [parameters allKeys];
            NSArray *sortedAllKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
            NSMutableString *string = [NSMutableString stringWithString:appId];
            for (NSString *key in sortedAllKeys) {
                [string appendString:key];
                id object = parameters[key];
                if ([object isKindOfClass:[NSString class]]) {
                    [string appendString:object];
                }
                else if ([object isKindOfClass:[NSNumber class]]) {
                    [string appendFormat:@"%@", object];
                }
                else {
                    NSLog(@"ERROR: unrecognized object: %@", object);
                }
            }
            [string appendString:secret];
            
            NSString *sha1 = [[string sha1String] uppercaseString];
            [request setValue:sha1 forHTTPHeaderField:@"sign"];
            
//            NSString *memberID = [[MMHAccountSession currentSession] memberID];
//            if (memberID.length != 0) {
//                [request setValue:memberID forHTTPHeaderField:@"memberId"];
//            }
//            else if (self.temporaryAccount) {
//                if (self.temporaryAccount.memberID.length != 0) {
//                    [request setValue:self.temporaryAccount.memberID forHTTPHeaderField:@"memberId"];
//                }
//            }
//            NSString *token = [[MMHAccountSession currentSession] token];
//            if (token.length != 0) {
//                [request setValue:token forHTTPHeaderField:@"token"];
//            }
//            else if (self.temporaryAccount) {
//                if (self.temporaryAccount.token.length != 0) {
//                    [request setValue:self.temporaryAccount.token forHTTPHeaderField:@"token"];
//                }
//            }
        }
    }
    return request;
}


@end

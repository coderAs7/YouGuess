//
//  MMHAccount.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHAccount.h"
//#import "MMHAddressSingleModel.h"
//#import "MMHSwift.h"


@implementation MMHAccount


- (instancetype)initWithJSONDict:(NSDictionary *)dict keyMap:(NSDictionary *)keyMap {
    self = [super initWithJSONDict:dict keyMap:keyMap];
    if (self) {
//        NSDictionary *defaultAddressDictionary = dict[@"defaultAddr"];
//        if (defaultAddressDictionary != nil) {
//            if (![defaultAddressDictionary isKindOfClass:[NSNull class]]) {
//                if (defaultAddressDictionary.count != 0) {
//                    self.defaultAddress = [[MMHAddressSingleModel alloc] initWithDictionary:defaultAddressDictionary];
//                }
//            }
//        }
    }
    return self;
}


- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"%@ = %@\n", @"userId", self.userId];
    [string appendFormat:@"%@ = %@\n", @"name", self.username];
    [string appendFormat:@"%@ = %@\n", @"nickname", self.nickname];
    [string appendFormat:@"%@ = %@\n", @"token", self.userToken];
    return string;
}


- (BOOL)shouldAutoLogin
{
    return YES;
}


- (BOOL)isActivated
{
    return YES;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userToken forKey:@"userToken"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.expireTime forKey:@"expireTime"];
    [aCoder encodeObject:self.avatar_url forKey:@"avatar_url"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.liveAddress forKey:@"liveAddress"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.userToken = [aDecoder decodeObjectForKey:@"userToken"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.expireTime = [aDecoder decodeObjectForKey:@"expireTime"];
        self.avatar_url = [aDecoder decodeObjectForKey:@"avatar_url"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.liveAddress = [aDecoder decodeObjectForKey:@"liveAddress"];
    }
    return self;
}

@end

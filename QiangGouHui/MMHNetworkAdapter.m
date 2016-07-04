//
//  MMHNetworkAdapter.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "MMHNetworkEngine.h"


@implementation MMHNetworkAdapter


+ (instancetype)sharedAdapter
{
    static MMHNetworkAdapter *_sharedAdapter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAdapter = [[MMHNetworkAdapter alloc] init];
    });
    return _sharedAdapter;
}


@end

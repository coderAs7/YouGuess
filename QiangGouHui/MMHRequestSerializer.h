//
//  MMHRequestSerializer.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "AFURLRequestSerialization.h"


@class MMHAccount;


@interface MMHRequestSerializer : AFHTTPRequestSerializer

@property (nonatomic, strong) MMHAccount *temporaryAccount;

@end

//
//  QGHPublic.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/15.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHPublic.h"

@implementation QGHPublic


+ (NSString *)notBlankString:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    return @"";
}


@end

//
//  QGHSKUCategory.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/4.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHSKUCategory.h"

@implementation QGHSKUCategory

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"skuId": @"id"};
}

@end

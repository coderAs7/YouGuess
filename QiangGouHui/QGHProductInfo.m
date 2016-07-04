//
//  QGHProductInfo.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/4.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductInfo.h"

@implementation QGHProductInfo

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"goodsId": @"id"};
}

@end

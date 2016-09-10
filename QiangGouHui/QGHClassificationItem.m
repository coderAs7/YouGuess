//
//  QGHClassificationItem.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHClassificationItem.h"

@implementation QGHClassificationItem

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"itemId": @"id", };
}

@end

//
//  QGHCartItem.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/6.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHCartItem.h"

@implementation QGHCartItem


- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"itemId": @"id"};
}


- (instancetype)initWithJSONDict:(NSDictionary *)dict {
    self = [super initWithJSONDict:dict];
    
    if (self) {
        self.isSelected = YES;
    }
    
    return self;
}


@end

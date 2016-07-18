//
//  QGHOrderListItem.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/25.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderListItem.h"

@implementation QGHOrderListItem


- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"orderId": @"id"};
}


- (instancetype)initWithJSONDict:(NSDictionary *)dict {
    self = [super initWithJSONDict:dict];
    
    if (self) {
        self.goodlist = [dict[@"goodlist"] modelArrayOfClass:[QGHOrderProduct class]];
    }
    
    return self;
}


@end

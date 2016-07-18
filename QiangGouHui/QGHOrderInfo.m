//
//  QGHOrderInfo.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/17.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderInfo.h"
#import "QGHOrderProduct.h"

@implementation QGHOrderInfo


- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"orderId": @"id"};
}


- (instancetype)initWithJSONDict:(NSDictionary *)dict {
    self = [super initWithJSONDict:dict];
    
    if (self) {
        self.goodlist = [[dict objectForKey:@"goodlist"] modelArrayOfClass:[QGHOrderProduct class]];
    }
    
    return self;
}


@end

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


- (instancetype)initWithJSONDict:(NSDictionary *)dict {
    self = [super initWithJSONDict:dict];
    
    if (self) {
        self.discount_price = [NSString stringWithFormat:@"%g", [[dict objectForKey:@"discount_price"] floatValue]];
    }
    
    return self;
}


@end

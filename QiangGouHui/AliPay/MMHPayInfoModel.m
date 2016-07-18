//
//  MMHPayInfoModel.m
//  MamHao
//
//  Created by SmartMin on 15/6/26.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHPayInfoModel.h"


@implementation MMHPayInfoModel


- (instancetype)initWithJSONDict:(NSDictionary *)dict keyMap:(NSDictionary *)keyMap {
    self = [super initWithJSONDict:dict keyMap:keyMap];
    if (self) {
        CGFloat priceValue = [dict[@"price"] floatValue];
        self.price = [NSString stringWithFormat:@"%.2f", priceValue];
    }
    return self;
}


@end

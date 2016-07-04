//
//  QGHProductDetailModel.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/4.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductDetailModel.h"

@implementation QGHProductDetailModel

- (instancetype)initWithJSONDict:(NSDictionary *)dict {
    self = [super initWithJSONDict:dict];
    
    if (self) {
        self.categorylist = [[dict objectForKey:@"categorylist"] modelArrayOfClass:[QGHSKUCategory class]];
        self.pricelist = [[dict objectForKey:@"pricelist"] modelArrayOfClass:[QGHSKUPrice class]];
        self.product = [[QGHProductInfo alloc] initWithJSONDict:[dict objectForKey:@"goodinfo"]];
    }
    
    return self;
}

@end

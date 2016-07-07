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


- (NSDictionary<NSString*, NSArray<QGHSKUCategory *> *> *)categoryDict {
    if (!_categoryDict) {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        
        for (QGHSKUCategory *sku in self.categorylist) {
            if (!tempDict[sku.name]) {
                tempDict[sku.name] = [NSMutableArray array];
            }
            
            [tempDict[sku.name] addObject:sku];
        }
        
        _categoryDict = [NSDictionary dictionaryWithDictionary:tempDict];
    }
    
    return _categoryDict;
}


- (BOOL)isAllSpecSelected {
    if (self.skuSelectModel.selectedSKU.count == self.categoryDict.count) {
        return  YES;
    }
    
    return NO;
}

@end

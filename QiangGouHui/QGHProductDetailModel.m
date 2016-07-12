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


- (QGHSKUSelectModel *)skuSelectModel {
    if (!_skuSelectModel) {
        _skuSelectModel = [[QGHSKUSelectModel alloc] init];
        _skuSelectModel.count = 1;
    }
    
    return _skuSelectModel;
}


- (BOOL)isAllSpecSelected {
    if (self.skuSelectModel.selectedSKU.count == self.categoryDict.count && self.categoryDict.count != 0) {
        return  YES;
    }
    
    return NO;
}


- (QGHSKUPrice *)allSepcSelectedPrice {
    if ([self isAllSpecSelected]) {
        NSArray *keys = [self.skuSelectModel.selectedSKU allKeys];
        NSMutableArray *selectSkuIdArr = [NSMutableArray array];
        for (NSString *key in keys) {
            [selectSkuIdArr addObject:((QGHSKUCategory *)self.skuSelectModel.selectedSKU[key]).skuId];
        }
        [selectSkuIdArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *str1 = (NSString *)obj1;
            NSString *str2 = (NSString *)obj2;
            return [str1 compare:str2];
        }];
        for (QGHSKUPrice *price in self.pricelist) {
            if ([price.category_id isEqualToArray:selectSkuIdArr]) {
                return price;
            }
        }
    }
    
    return nil;
}


@end

//
//  QGHSKUSelectModel.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/7.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHSKUSelectModel.h"

@implementation QGHSKUSelectModel


- (NSMutableDictionary *)selectedSKU {
    if (!_selectedSKU) {
        _selectedSKU = [[NSMutableDictionary alloc] init];
    }
    
    return _selectedSKU;
}


- (NSArray *)selectedSKUValues {
    NSArray *keys = self.selectedSKU.allKeys;
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *key in keys) {
        [values addObject:((QGHSKUCategory *)self.selectedSKU[key]).value];
    }
    
    return values;
}


- (NSArray *)selectedSKUIds {
    NSArray *keys = self.selectedSKU.allKeys;
    NSMutableArray *ids = [NSMutableArray array];
    for (NSString *key in keys) {
        [ids addObject:((QGHSKUCategory *)self.selectedSKU[key]).skuId];
    }
    
    return ids;
}


@end

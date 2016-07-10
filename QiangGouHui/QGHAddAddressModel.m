//
//  QGHAddAddressModel.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHAddAddressModel.h"

@implementation QGHAddAddressModel


- (NSString *)province {
    if (!_province) {
        return @"";
    }
    
    return _province;
}


- (NSString *)city {
    if (!_city) {
        return @"";
    }
    
    return _city;
}


- (NSString *)area {
    if (!_area) {
        return @"";
    }
    
    return _area;
}


@end

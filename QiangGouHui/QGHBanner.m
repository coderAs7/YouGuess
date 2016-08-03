//
//  QGHBanner.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/24.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHBanner.h"


@implementation QGHBanner


- (instancetype)initWithJSONDict:(NSDictionary *)dict {
    self = [super initWithJSONDict:dict];
    
    if (self) {
        self.type = [dict[@"type"] integerValue];
    }
    
    return self;
}


@end

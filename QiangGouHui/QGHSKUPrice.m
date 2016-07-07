//
//  QGHSKUPrice.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/4.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHSKUPrice.h"


@implementation QGHSKUPrice


- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"priceId": @"id"};
}


//- (instancetype)initWithJSONDict:(NSDictionary *)dict {
//    self = [super initWithJSONDict:dict];
//    
//    if (self) {
//        NSString *categoryIds = [dict objectForKey:@"category_id"];
//        if (categoryIds.length > 0) {
//            NSString *tempString = [categoryIds substringWithRange:NSMakeRange(1, categoryIds.length - 2)];
//            self.category_id = [tempString componentsSeparatedByString:@","];
//        }
//    }
//    
//    return self;
//}


@end

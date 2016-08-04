//
//  QGHGroupUserModel.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/8/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHGroupUserModel.h"

@implementation QGHGroupUserModel


- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"userId": @"id"};
}


@end

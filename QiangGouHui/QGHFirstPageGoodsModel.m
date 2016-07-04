//
//  QGHGoodsModel.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHFirstPageGoodsModel.h"

@implementation QGHFirstPageGoodsModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"goodsId": @"id"};
}

@end

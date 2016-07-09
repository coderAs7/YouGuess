//
//  QGHReceiptAddressModel.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/9.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHReceiptAddressModel.h"

@implementation QGHReceiptAddressModel


- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"receiptAddressId": @"id"};
}


@end

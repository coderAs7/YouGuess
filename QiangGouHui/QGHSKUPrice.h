//
//  QGHSKUPrice.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/4.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHSKUPrice : MMHFetchModel

@property (nonatomic, copy) NSString *priceId;
@property (nonatomic, strong) NSArray *category_id;
@property (nonatomic, copy) NSString *original_price;
@property (nonatomic, copy) NSString *discount_price;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *code;

@end

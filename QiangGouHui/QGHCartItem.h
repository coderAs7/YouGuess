//
//  QGHCartItem.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/6.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHCartItem : MMHFetchModel

@property (nonatomic, copy) NSString *good_id;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sub_title;
@property (nonatomic, copy) NSString *img_path;
@property (nonatomic, assign) float min_price;
@property (nonatomic, assign) float original_price;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *purchase_num;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *sku;
@property (nonatomic, copy) NSString *skuId;
@property (nonatomic, assign) int count;

@property (nonatomic, assign) BOOL isSelected;

@end

//
//  QGHGoodsModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHFirstPageGoodsModel : MMHFetchModel

@property (nonatomic, copy) NSString *appointment;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, assign) NSInteger create_time;
@property (nonatomic, assign) float discount_price;
@property (nonatomic, assign) NSInteger end_time;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, assign) float original_price;
@property (nonatomic, assign) NSInteger production_time;
@property (nonatomic, assign) NSInteger range;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sub_title;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *img_path;
@property (nonatomic, copy) NSString *min_price;
@property (nonatomic, assign) QGHBussType type;
@end

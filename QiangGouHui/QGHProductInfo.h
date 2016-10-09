//
//  QGHProductInfo.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/4.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHProductInfo : MMHFetchModel

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sub_title;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *range;
@property (nonatomic, copy) NSString *status; //1：有效，2：下架
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *type; //1：普通，2：抢购，3:预约，4:定制
@property (nonatomic, copy) NSString *purchase_num;
@property (nonatomic, strong) NSArray *img_path;
@property (nonatomic, copy) NSString *appointment;
@property (nonatomic, copy) NSString *production_time;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *min_price;
@property (nonatomic, copy) NSString *original_price;
@property (nonatomic, copy) NSString *discount_price;
@property (nonatomic, copy) NSString *supplier;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) double end_time;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *shareurl;

@end

//
//  QGHOrderProduct.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/17.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHOrderProduct : MMHFetchModel

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *good_name;
@property (nonatomic, copy) NSString *img_path;
@property (nonatomic, assign) float min_price;
@property (nonatomic, copy) NSString *sku;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int status;
@property (nonatomic ,assign) float amount;
@property (nonatomic, assign) int posType;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *posttype;
@property (nonatomic, copy) NSString *postid;

@end

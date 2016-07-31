//
//  QGHMessageProductModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/31.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHMessageProductModel : MMHFetchModel

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *price;

@end

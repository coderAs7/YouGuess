//
//  QGHProductList.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/22.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHTimeline.h"


@class MMHFilter;


@interface QGHProductList : MMHTimeline

- (instancetype)initWithFilter:(MMHFilter *)filter;

@end

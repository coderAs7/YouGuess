//
//  QGHProductDetailModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/4.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"
#import "QGHSKUCategory.h"
#import "QGHSKUPrice.h"
#import "QGHProductInfo.h"


@interface QGHProductDetailModel : MMHFetchModel

@property (nonatomic, strong) NSArray<QGHSKUCategory *> *categorylist;
@property (nonatomic, strong) NSArray<QGHSKUPrice *> *pricelist;
@property (nonatomic, strong) QGHProductInfo *product;

@end

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
#import "QGHSKUSelectModel.h"


@interface QGHProductDetailModel : MMHFetchModel

@property (nonatomic, strong) NSArray<QGHSKUCategory *> *categorylist;
@property (nonatomic, strong) NSArray<QGHSKUPrice *> *pricelist;
@property (nonatomic, strong) QGHProductInfo *product;

@property (nonatomic, strong) NSDictionary<NSString*, NSArray<QGHSKUCategory *> *> *categoryDict;


@property (nonatomic, strong) QGHSKUSelectModel *skuSelectModel;

- (BOOL)isAllSpecSelected;
- (QGHSKUPrice *)allSepcSelectedPrice;

@end

//
//  QGHConfirmOrderViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/2.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"
#import "QGHProductDetailModel.h"
#import "QGHCartItem.h"


@interface QGHConfirmOrderViewController : BaseViewController

- (instancetype)initWithBussType:(QGHBussType)type productDetail:(QGHProductDetailModel *)productDetail;
- (instancetype)initWithCartItemArr:(NSArray<QGHCartItem *> *)cartItemArr;

@end

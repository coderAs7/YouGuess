//
//  QGHOrderDetailProductCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/26.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QGHProductDetailModel;
@class QGHCartItem;
@class QGHOrderProduct;


@interface QGHOrderDetailProductCell : UITableViewCell

@property (nonatomic, strong) QGHProductDetailModel *productDetailModel;

@property (nonatomic, strong) QGHCartItem *cartItem;

@property (nonatomic, strong) QGHOrderProduct *orderProduct;

@end

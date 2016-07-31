//
//  QGHRushPurchaseItemView.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGHFirstPageGoodsModel.h"


@protocol  QGHRushPurchaseItemViewDelegate<NSObject>

- (void)purchaseItemDidSelect:(QGHFirstPageGoodsModel *)goods;

@end


@interface QGHRushPurchaseItemView : UIView

@property (nonatomic, weak) id<QGHRushPurchaseItemViewDelegate> delegate;

- (void)setGoodsModel:(QGHFirstPageGoodsModel *)goods;

@end

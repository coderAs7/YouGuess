//
//  QGHProductDetailPriceCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/26.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGHProductDetailModel.h"

typedef NS_ENUM(NSInteger, QGHProductDetailPriceCellType) {
    QGHProductDetailPriceCellTypeCommon,
    QGHProductDetailPriceCellTypeCustomized,
    QGHProductDetailPriceCellTypePurchase,
    QGHProductDetailPriceCellTypeAppoint,
};


@interface QGHProductDetailPriceCell : UITableViewCell

- (void)setData:(QGHProductDetailModel *)model;

@end

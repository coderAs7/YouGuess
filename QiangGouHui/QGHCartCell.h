//
//  QGHCartCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/2.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGHCartItem.h"


@class QGHCartCell;


@protocol QGHCartCellDelegate <NSObject>

- (void)cartCellModifyCount:(QGHCartCell *)cell changeValueFrom:(NSInteger)currentValue to:(NSInteger)newValue;
- (void)cartCellDeleteItem:(QGHCartCell *)cell;
- (void)cartCellSelectItem:(QGHCartCell *)cell;

@end


@interface QGHCartCell : UITableViewCell

@property (nonatomic, weak) id<QGHCartCellDelegate> delegate;
@property (nonatomic, strong) QGHCartItem *cartItem;

@end

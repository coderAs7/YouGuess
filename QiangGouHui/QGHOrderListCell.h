//
//  QGHOrderListCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/25.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QGHOrderListCell;


@protocol QGHOrderListCellDelegate <NSObject>

- (void)orderListCellDidClickButton1:(QGHOrderListCell *)cell;

@end


@interface QGHOrderListCell : UITableViewCell

@property (nonatomic, weak) id<QGHOrderListCellDelegate> delegate;

@end

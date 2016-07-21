//
//  QGHOrderListBottomCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/17.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QGHOrderListItem;
@class QGHOrderListBottomCell;


@protocol QGHOrderListBottomCellDelegate <NSObject>

- (void)orderListBottomCellToPay:(QGHOrderListBottomCell *)cell;
- (void)orderListBottomCellToCancel:(QGHOrderListBottomCell *)cell;
- (void)orderListBottomCellToPayApplyRefunding:(QGHOrderListBottomCell *)cell;
- (void)orderListBottomCellToLookExpress:(QGHOrderListBottomCell *)cell;
- (void)orderListBottomCellToConfirmReceipt:(QGHOrderListBottomCell *)cell;
- (void)orderListBottomCellToComment:(QGHOrderListBottomCell *)cell;
- (void)orderListBottomCellToRefundAndGoods:(QGHOrderListBottomCell *)cell;
- (void)orderListBottomCellToDeleteOrder:(QGHOrderListBottomCell *)cell;

@end


@interface QGHOrderListBottomCell : UITableViewCell

@property (nonatomic, weak) id<QGHOrderListBottomCellDelegate> delegate;
@property (nonatomic, strong) QGHOrderListItem *item;

@end

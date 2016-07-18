//
//  QGHOrderListBottomCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/17.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QGHOrderListItem;


@protocol QGHOrderListBottomCellDelegate <NSObject>

- (void)orderListBottomCellToPay;
- (void)orderListBottomCellToLookExpress;
- (void)orderListBottomCellToConfirmReceipt;
- (void)orderListBottomCellToComment;
- (void)orderListBottomCellToPursueRefund;
- (void)orderListBottomCellToDeleteOrder;

@end


@interface QGHOrderListBottomCell : UITableViewCell

@property (nonatomic, weak) id<QGHOrderListBottomCellDelegate> delegate;
@property (nonatomic, strong) QGHOrderListItem *item;

@end

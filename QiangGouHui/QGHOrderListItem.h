//
//  QGHOrderListItem.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/25.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"
#import "QGHOrderProduct.h"


typedef NS_ENUM(NSInteger, QGHOrderListItemStatus) {
    QGHOrderListItemStatusAll = 999,
    QGHOrderListItemStatusToPay = 2,
    QGHOrderListItemStatusToExpress = 3,
    QGHOrderListItemStatusToReceipt = 4,
    QGHOrderListItemStatusToComment = 5,
    QGHOrderListItemStatusFinish = 1,
    QGHOrderListItemStatusCancel = 10,
    QGHOrderListItemStatusRefund = 6,
};


@interface QGHOrderListItem : MMHFetchModel

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, assign) float amount;
@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, strong) NSArray<QGHOrderProduct *> *goodlist;
@property (nonatomic, assign) QGHOrderListItemStatus status;
@property (nonatomic, assign) int type;

@end

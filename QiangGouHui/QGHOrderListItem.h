//
//  QGHOrderListItem.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/25.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"


typedef NS_ENUM(NSInteger, QGHOrderListItemStatus) {
    QGHOrderListItemStatusToPay,
    QGHOrderListItemStatusToReceipt,
    QGHOrderListItemStatusToComment,
    QGHOrderListItemStatusFinish,
    QGHOrderListItemStatusRefund,
    QGHOrderListItemStatusCancel,
};


@interface QGHOrderListItem : MMHFetchModel

@end

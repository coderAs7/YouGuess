//
//  QGHOrderInfo.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/17.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"
#import "QGHReceiptAddressModel.h"
#import "QGHOrderListItem.h"

@class QGHOrderProduct;


@interface QGHOrderInfo : MMHFetchModel

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) float amount;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) float postage;
@property (nonatomic, assign) QGHOrderListItemStatus status;
@property (nonatomic, strong) NSArray<QGHOrderProduct *> *goodlist;
@property (nonatomic, strong) QGHReceiptAddressModel *receiptinfo;
@property (nonatomic, copy) NSString *posttype;
@property (nonatomic, copy) NSString *postid;

@end

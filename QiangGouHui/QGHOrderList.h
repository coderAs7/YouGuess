//
//  QGHOrderList.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/17.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHTimeline.h"
#import "MMHNetworkAdapter+Order.h"


@interface QGHOrderList : MMHTimeline

- (instancetype)initWithStatus:(QGHOrderListItemStatus)status;

@end

//
//  MMHNetworkAdapter+Cart.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/6.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "QGHCartItem.h"

@interface MMHNetworkAdapter (Cart)

- (void)fetchCartListFrom:(id)requester succeededHandler:(void(^)(NSArray<QGHCartItem *> *itemArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

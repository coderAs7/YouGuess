//
//  MMHNetworkAdapter+Personal.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/22.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "QGHOrderNumModel.h"

@interface MMHNetworkAdapter (Personal)

- (void)fetchOrderNumFrom:(id)requester succeededHandler:(void(^)(QGHOrderNumModel *orderNum))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

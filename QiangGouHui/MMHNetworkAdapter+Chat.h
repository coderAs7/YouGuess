//
//  MMHNetworkAdapter+Chat.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/28.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "QGHGroupModel.h"

@interface MMHNetworkAdapter (Chat)

- (void)fetchGroupListFrom:(id)requester succeededHandler:(void(^)(NSArray<QGHGroupModel *> *groupArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;
@end

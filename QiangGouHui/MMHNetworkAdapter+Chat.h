//
//  MMHNetworkAdapter+Chat.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/28.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "QGHGroupModel.h"
#import "QGHGroupUserModel.h"

@interface MMHNetworkAdapter (Chat)

- (void)fetchGroupListFrom:(id)requester succeededHandler:(void(^)(NSArray<QGHGroupModel *> *groupArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)fetchGroupUserListFrom:(id)requester userIds:(NSString *)userIds succeededHandler:(void(^)(NSArray<QGHGroupUserModel *> *groupUserArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

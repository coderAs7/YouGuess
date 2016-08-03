//
//  MMHNetworkAdapter+Chat.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/28.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+Chat.h"

@implementation MMHNetworkAdapter (Chat)


- (void)fetchGroupListFrom:(id)requester succeededHandler:(void(^)(NSArray<QGHGroupModel *> *groupArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_imgroup_list_001" parameters:@{@"userToken": [[MMHAccountSession currentSession] token]} from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSArray *groupArr = [responseJSONObject[@"info"] modelArrayOfClass:[QGHGroupModel class]];
        succeededHandler(groupArr);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end
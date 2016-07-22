//
//  MMHNetworkAdapter+Personal.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/22.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+Personal.h"

@implementation MMHNetworkAdapter (Personal)

- (void)fetchOrderNumFrom:(id)requester succeededHandler:(void(^)(QGHOrderNumModel *orderNum))  succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_ordernum_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        QGHOrderNumModel *orderNum = [[QGHOrderNumModel alloc] initWithJSONDict:responseJSONObject[@"info"]];
        succeededHandler(orderNum);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}

@end

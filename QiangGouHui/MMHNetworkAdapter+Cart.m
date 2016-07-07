//
//  MMHNetworkAdapter+Cart.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/6.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+Cart.h"

@implementation MMHNetworkAdapter (Cart)


- (void)fetchCartListFrom:(id)requester succeededHandler:(void(^)(NSArray<QGHCartItem *> *itemArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_card_list_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        //
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

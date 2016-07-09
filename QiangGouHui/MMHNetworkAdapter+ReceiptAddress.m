//
//  MMHNetworkAdapter+ReceiptAddress.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/9.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+ReceiptAddress.h"

@implementation MMHNetworkAdapter (ReceiptAddress)


- (void)fetchReceiptAddressListFrom:(id)requester succeededHandler:(void (^)(NSArray<QGHReceiptAddressModel *> *receiptAddressArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_receipt_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSArray *receiptArr = [[responseJSONObject objectForKey:@"info"] modelArrayOfClass:[QGHReceiptAddressModel class]];
        succeededHandler(receiptArr);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

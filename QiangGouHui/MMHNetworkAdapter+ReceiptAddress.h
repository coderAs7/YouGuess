//
//  MMHNetworkAdapter+ReceiptAddress.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/9.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "QGHReceiptAddressModel.h"


@interface MMHNetworkAdapter (ReceiptAddress)

- (void)fetchReceiptAddressListFrom:(id)requester succeededHandler:(void (^)(NSArray<QGHReceiptAddressModel *> *receiptAddressArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

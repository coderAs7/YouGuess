//
//  MMHNetworkAdapter+ReceiptAddress.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/9.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "QGHReceiptAddressModel.h"


@class QGHAddAddressModel;


@interface MMHNetworkAdapter (ReceiptAddress)

- (void)fetchReceiptAddressListFrom:(id)requester succeededHandler:(void (^)(NSArray<QGHReceiptAddressModel *> *receiptAddressArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)fetchDefaultReceiptAddressFrom:(id)requester succeededHandler:(void (^)(QGHReceiptAddressModel *))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)setDefaultReceiptAddressFrom:(id)requester addressId:(NSString *)addressId succeededHandler:(void (^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)deleteReceiptAddressFrom:(id)requester addressId:(NSString *)addressId succeededHandler:(void (^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)addOrModifyAddressFrom:(id)requester deliveryId:(NSString *)deliveryId addAddressModel:(QGHReceiptAddressModel *)model succeededHandler:(void (^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

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

- (void)addCartFrom:(id)requester goodsId:(NSString *)goodsId count:(NSInteger)count price:(NSString *)price skuId:(NSString *)skuId succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)modifyCartCountFrom:(id)requester goodsId:(NSString *)goodsId count:(NSInteger)count price:(NSString *)price itemId:(NSString *)itemId succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)deleteCartItemFrom:(id)requester itemId:(NSString *)itemId succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

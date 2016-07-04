//
//  MMHNetworkAdapter+FirstPage.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"

@class QGHFirstPageGoodsModel;

@interface MMHNetworkAdapter (FirstPage)

- (void)fetchDataWithRequester:(id)requester bussType:(QGHBussType)type area:(NSString *)area page:(NSInteger)page size:(NSInteger)size succeededHandler:(void(^)(NSArray<QGHFirstPageGoodsModel *> *goodsArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

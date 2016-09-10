//
//  MMHNetworkAdapter+FirstPage.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"


@class QGHFirstPageGoodsModel;
@class QGHBanner;
@class QGHClassificationItem;


@interface MMHNetworkAdapter (FirstPage)

- (void)fetchDataWithRequester:(id)requester bussType:(QGHBussType)type area:(NSString *)area page:(NSInteger)page size:(NSInteger)size succeededHandler:(void(^)(NSArray<QGHFirstPageGoodsModel *> *goodsArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)fetchBannerFrom:(id)requester succeededHandler:(void(^)(NSArray<QGHBanner *> *bannerArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)fetchClassficationFrom:(id)requester succeededHandler:(void(^)(NSArray<QGHClassificationItem *> *itemArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

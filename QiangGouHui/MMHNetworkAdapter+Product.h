//
//  MMHNetworkAdapter+Product.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/4.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "QGHProductDetailModel.h"
#import "QGHProductDetailScoreInfo.h"
#import "QGHProductDetailComment.h"


@interface MMHNetworkAdapter (Product)

- (void)fetchDataWithRequester:(id)requester goodsId:(NSString *)goodsId succeededHandler:(void(^)(QGHProductDetailModel *productDetailModel))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)fetchProductCommentsWithRequester:(id)requester goodsId:(NSString *)goodsId page:(NSInteger)page size:(NSInteger)size succeededHandler:(void (^)(QGHProductDetailScoreInfo *scoreInfo, NSArray<QGHProductDetailComment *> *commentArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;
@end

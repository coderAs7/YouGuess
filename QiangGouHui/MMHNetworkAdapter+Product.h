//
//  MMHNetworkAdapter+Product.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/4.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "QGHProductDetailModel.h"


@interface MMHNetworkAdapter (Product)

- (void)fetchDataWithRequester:(id)requester goodsId:(NSString *)goodsId succeededHandler:(void(^)(QGHProductDetailModel *productDetailModel))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

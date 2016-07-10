//
//  MMHNetworkAdapter+Order.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"

@interface MMHNetworkAdapter (Order)

- (void)fetchMailPriceFrom:(id)requester goodsId:(NSString *)goodsId province:(NSString *)province succeededHandler:(void (^)(float mailPrice))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

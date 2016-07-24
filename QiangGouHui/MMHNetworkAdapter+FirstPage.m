//
//  MMHNetworkAdapter+FirstPage.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+FirstPage.h"
#import "MMHAccountSession.h"
#import "QGHFirstPageGoodsModel.h"
#import "QGHBanner.h"

@implementation MMHNetworkAdapter (FirstPage)


- (void)fetchDataWithRequester:(id)requester bussType:(QGHBussType)type area:(NSString *)area page:(NSInteger)page size:(NSInteger)size succeededHandler:(void(^)(NSArray<QGHFirstPageGoodsModel *> *goodsArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
        NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token], @"type": @(type), @"area": area, @"page": @(page), @"size": @(size)};
        MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_goods_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:@{@"goodsId": @"id"} succeededBlock:^(id responseObject, id responseJSONObject) {
            NSArray *data = [responseJSONObject objectForKey:@"info"];
            NSArray *goodsArr = [data modelArrayOfClass:[QGHFirstPageGoodsModel class]];
            succeededHandler(goodsArr);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)fetchBannerFrom:(id)requester succeededHandler:(void(^)(NSArray<QGHBanner *> *bannerArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_active_index_001" parameters:@{} from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSArray *bannerArr = [responseJSONObject[@"info"] modelArrayOfClass:[QGHBanner class]];
        succeededHandler(bannerArr);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

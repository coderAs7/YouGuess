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
#import "QGHClassificationItem.h"


@implementation MMHNetworkAdapter (FirstPage)


- (void)fetchDataWithRequester:(id)requester goodstype:(NSString *)goodstype bussType:(QGHBussType)type area:(NSString *)area page:(NSInteger)page size:(NSInteger)size succeededHandler:(void(^)(NSArray<QGHFirstPageGoodsModel *> *goodsArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSMutableDictionary *parameters = [@{@"userToken": [[MMHAccountSession currentSession] token], @"type": @(type), @"area": [QGHPublic notBlankString:area], @"page": @(page), @"size": @(size)} mutableCopy];
    if (goodstype.length > 0) {
        [parameters addEntriesFromDictionary:@{@"goodstype": goodstype}];
    }
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


- (void)fetchClassficationFrom:(id)requester succeededHandler:(void(^)(NSArray<QGHClassificationItem *> *itemArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_goodstype_list_001" parameters:@{} from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSArray *dataArr = responseJSONObject[@"info"];
        NSMutableArray *itemArr = [NSMutableArray array];
        for (NSDictionary *dataDict in dataArr) {
            QGHClassificationItem *topItem = [[QGHClassificationItem alloc] initWithJSONDict:dataDict];
            NSArray *twoSubArr = [dataDict objectForKey:@"two_sub_type"];
            if (twoSubArr) {
                topItem.canUnfold = YES;
            }
            topItem.isUnfold = NO;
            topItem.level = 0;
            
            NSMutableArray *twoItemArr = [NSMutableArray array];
            for (NSDictionary *twoSubDic in twoSubArr) {
                QGHClassificationItem *twoItem = [[QGHClassificationItem alloc] initWithJSONDict:twoSubDic];
                NSArray *threeSubArr = [twoSubDic objectForKey:@"three_sub_type"];
                if (threeSubArr) {
                    twoItem.canUnfold = YES;
                }
                twoItem.isUnfold = NO;
                twoItem.level = 1;
                
                NSMutableArray *threeItemArr = [NSMutableArray array];
                for (NSDictionary *threeSubDic in threeSubArr) {
                    QGHClassificationItem *threeItem = [[QGHClassificationItem alloc] initWithJSONDict:threeSubDic];
                    threeItem.canUnfold = NO;
                    threeItem.isUnfold = NO;
                    threeItem.level = 2;
                    [threeItemArr addObject:threeItem];
                }
                twoItem.itemArr = threeItemArr;
                [twoItemArr addObject:twoItem];
            }
            topItem.itemArr = twoItemArr;
            [itemArr addObject:topItem];
        }
        succeededHandler(itemArr);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

//
//  MMHNetworkAdapter+Product.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/4.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+Product.h"


@implementation MMHNetworkAdapter (Product)


- (void)fetchDataWithRequester:(id)requester goodsId:(NSString *)goodsId succeededHandler:(void(^)(QGHProductDetailModel *productDetailModel))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token], @"id": goodsId};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_goods_info_001" parameters:parameters from:requester responseObjectClass:[QGHProductDetailModel class] responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        QGHProductDetailModel *model = [[QGHProductDetailModel alloc] initWithJSONDict:[responseJSONObject objectForKey:@"info"]];
        succeededHandler(model);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)fetchProductCommentsWithRequester:(id)requester goodsId:(NSString *)goodsId page:(NSInteger)page size:(NSInteger)size succeededHandler:(void (^)(QGHProductDetailScoreInfo *scoreInfo, NSArray<QGHProductDetailComment *> *commentArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token], @"good_id": goodsId, @"page": @(page), @"size": @(size)};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_comment_002" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSInteger code = [responseJSONObject[@"error"] integerValue];
        if (code == 0) {
            NSDictionary *info = responseJSONObject[@"info"];
            QGHProductDetailScoreInfo *scoreInfo = [[QGHProductDetailScoreInfo alloc] initWithJSONDict:[info objectForKey:@"sorceinfo"]];
            NSArray *commentArr = [[info objectForKey:@"data"] modelArrayOfClass:[QGHProductDetailComment class]];
            succeededHandler(scoreInfo, commentArr);
        }
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}

@end

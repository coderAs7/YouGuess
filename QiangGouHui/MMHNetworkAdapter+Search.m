//
//  MMHNetworkAdapter+Search.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/21.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+Search.h"
#import "QGHFirstPageGoodsModel.h"


@implementation MMHNetworkAdapter (Search)


- (void)fetchHotKeyListFrom:(id)requester succeededHandler:(void(^)(NSArray *keywords))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_hotkey_list_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSArray *keywords = responseJSONObject[@"info"];
        NSMutableArray *keywordsArr = [NSMutableArray array];
        for (NSString *str in keywords) {
            [keywordsArr addObject:str];
        }
        succeededHandler(keywordsArr);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)searchGoodFrom:(id)requester keyword:(NSString *)keyword searchType:(MMHSortType)searchType sortOrder:(MMHSortOrder)sortOrder page:(NSInteger)page size:(NSInteger)size succeededHandler:(void(^)(NSArray<QGHFirstPageGoodsModel *> *productArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    if (sortOrder == MMHSortOrderIgnored) {
        sortOrder = MMHSortOrderDescending;
    }
    NSDictionary *parameters = @{@"key": keyword, @"search_type": @(searchType), @"sort": @(sortOrder), @"page": @(page), @"size": @(size)};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_search_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        NSArray *productArr = [responseJSONObject[@"info"] modelArrayOfClass:[QGHFirstPageGoodsModel class]];
        succeededHandler(productArr);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

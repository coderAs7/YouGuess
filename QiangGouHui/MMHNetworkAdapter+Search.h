//
//  MMHNetworkAdapter+Search.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/21.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"
#import "MMHSort.h"


@class QGHFirstPageGoodsModel;


@interface MMHNetworkAdapter (Search)

- (void)fetchHotKeyListFrom:(id)requester succeededHandler:(void(^)(NSArray *keywords))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)searchGoodFrom:(id)requester keyword:(NSString *)keyword searchType:(MMHSortType)searchType sortOrder:(MMHSortOrder)sortOrder page:(NSInteger)page size:(NSInteger)size succeededHandler:(void(^)(NSArray<QGHFirstPageGoodsModel *> *productArr))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

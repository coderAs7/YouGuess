//
//  MMHNetworkAdapter+Search.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/21.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter.h"

@interface MMHNetworkAdapter (Search)

- (void)fetchHotKeyListFrom:(id)requester succeededHandler:(void(^)(NSArray *keywords))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

- (void)searchGoodFrom:(id)requester succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler;

@end

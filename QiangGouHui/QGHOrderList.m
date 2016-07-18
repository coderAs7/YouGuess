//
//  QGHOrderList.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/17.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderList.h"


@interface QGHOrderList ()

@property (nonatomic, assign) QGHOrderListItemStatus status;

@end


@implementation QGHOrderList


- (instancetype)initWithStatus:(QGHOrderListItemStatus)status {
    self = [super init];
    
    if (self) {
        _status = status;
    }
    
    return self;
}


- (void)fetchItemsAtPage:(NSInteger)page succeededHandler:(void (^)(NSArray * _Nonnull))succeededHandler failedHandler:(void (^)(NSError * _Nonnull))failedHandler {
    [[MMHNetworkAdapter sharedAdapter] fetchOrderListFrom:self status:self.status page:page + 1 size:self.pageSize succeededHandler:^(NSArray<QGHOrderListItem *> *orderList) {
        succeededHandler(orderList);
    } failedHandler:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

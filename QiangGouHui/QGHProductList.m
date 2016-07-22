//
//  QGHProductList.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/22.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductList.h"
#import "MMHNetworkAdapter+Search.h"
#import "MMHFilter.h"
#import "QGHFirstPageGoodsModel.h"


@interface QGHProductList ()

@property (nonatomic, strong) MMHFilter *filter;

@end


@implementation QGHProductList


- (instancetype)initWithFilter:(MMHFilter *)filter {
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}


- (void)fetchItemsAtPage:(NSInteger)page succeededHandler:(void (^)(NSArray * _Nonnull))succeededHandler failedHandler:(void (^)(NSError * _Nonnull))failedHandler {
    MMHFilter *filter = self.filter;
    [[MMHNetworkAdapter sharedAdapter] searchGoodFrom:self keyword:filter.keyword searchType:filter.sort.type sortOrder:filter.sort.order page:page + 1 size:self.pageSize succeededHandler:^(NSArray<QGHFirstPageGoodsModel *> *productArr) {
        succeededHandler(productArr);
    } failedHandler:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

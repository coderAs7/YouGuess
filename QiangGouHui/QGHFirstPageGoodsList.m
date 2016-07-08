//
//  QGHFirstPageGoodsList.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHFirstPageGoodsList.h"
#import "MMHNetworkAdapter+FirstPage.h"


@interface QGHFirstPageGoodsList ()

@property (nonatomic, assign) QGHBussType flag;
@property (nonatomic, copy) NSString *city;

@end


@implementation QGHFirstPageGoodsList


- (instancetype)initWithFlag:(NSInteger)flag city:(NSString *)city {
    self = [super init];
    
    if (self) {
        _flag = flag;
        _city = city;
    }
    
    return self;
}


- (void)fetchItemsAtPage:(NSInteger)page succeededHandler:(void (^)(NSArray * _Nonnull))succeededHandler failedHandler:(void (^)(NSError * _Nonnull))failedHandler {
    [[MMHNetworkAdapter sharedAdapter] fetchDataWithRequester:self bussType:self.flag area:self.city page:page + 1 size:self.pageSize succeededHandler:^(NSArray<QGHFirstPageGoodsModel *> *goodsArr){
        succeededHandler(goodsArr);
    } failedHandler:failedHandler];
    
}


@end
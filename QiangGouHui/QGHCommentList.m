//
//  QGHCommentList.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/24.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHCommentList.h"
#import "MMHNetworkAdapter+Product.h"


@interface QGHCommentList ()

@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong, readwrite) QGHProductDetailScoreInfo *scoreInfo;

@end


@implementation QGHCommentList


- (instancetype)initWithGoodsId:(NSString *)goodsId {
    self = [super init];
    
    if (self) {
        _goodsId = goodsId;
    }
    
    return self;
}


- (void)fetchItemsAtPage:(NSInteger)page succeededHandler:(void (^)(NSArray * _Nonnull))succeededHandler failedHandler:(void (^)(NSError * _Nonnull))failedHandler {
    [[MMHNetworkAdapter sharedAdapter] fetchProductCommentsWithRequester:self goodsId:self.goodsId page:1 size:10 succeededHandler:^(QGHProductDetailScoreInfo *scoreInfo, NSArray<QGHProductDetailComment *> *commentArr) {
        self.scoreInfo = scoreInfo;
        succeededHandler(commentArr);
    } failedHandler:^(NSError *error) {
        failedHandler(error);
    }];
}


@end

//
//  QGHToSettlementModel.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/12.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHToSettlementModel.h"
#import "QGHProductDetailModel.h"
#import "MMHAccountSession.h"


@implementation QGHToSettlementModel


- (NSDictionary *)parameters {
    NSMutableArray *goodInfoArr = [NSMutableArray array];
    for (QGHProductDetailModel *product in self.productArr) {
        NSMutableDictionary *goodInfoDict = [@{@"good_id": product.product.goodsId, @"count": @(product.skuSelectModel.count), @"price": product.product.min_price} mutableCopy];
        if ([product isAllSpecSelected]) {
            QGHSKUPrice *skuPrice = [product allSepcSelectedPrice];
            [goodInfoDict addEntriesFromDictionary:@{@"sku": skuPrice.priceId}];
        }
        [goodInfoArr addObject:goodInfoDict];
    }
    
    NSString *transferType;
    if (self.bussType == QGHBussTypeNormal || self.bussType == QGHBussTypePurchase) {
        transferType = @"1";
    } else if (self.bussType == QGHBussTypeAppoint) {
        transferType = @"2";
    } else {
        transferType = @"3";
    }
    
    return @{@"userToken": [[MMHAccountSession currentSession] token],
             @"receipt_id": self.receiptId,
             @"auto": self.autoOrder,
             @"good_info": [goodInfoArr mmh_JSONString],
             @"type": transferType};
}


@end

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
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSMutableArray *goodInfoArr = [NSMutableArray array];
    for (QGHProductDetailModel *product in self.productArr) {
        NSMutableDictionary *goodInfoDict = [@{@"good_id": product.product.goodsId, @"count": @(product.skuSelectModel.count)} mutableCopy];
        if ([product isAllSpecSelected]) {
            QGHSKUPrice *skuPrice = [product allSepcSelectedPrice];
            [goodInfoDict addEntriesFromDictionary:@{@"sku": skuPrice.priceId}];
            [goodInfoDict addEntriesFromDictionary:@{@"price": skuPrice.discount_price}];
        } else {
            [goodInfoDict addEntriesFromDictionary:@{@"price": product.product.discount_price}];
        }
        [goodInfoArr addObject:goodInfoDict];
    }
    
    parameters = [@{@"userToken": [[MMHAccountSession currentSession] token], @"receipt_id": self.receiptId, @"postage": [NSString stringWithFormat:@"%.1f", self.mailPrice], @"amount": @(self.amount), @"note": self.note} mutableCopy];
    
    if ([self.autoOrder isEqualToString:@"1"]) {
        NSString *transferType;
        if (self.bussType == QGHBussTypeNormal || self.bussType == QGHBussTypePurchase) {
            transferType = @"1";
        } else if (self.bussType == QGHBussTypeAppoint) {
            transferType = @"2";
        } else {
            transferType = @"3";
        }
        [parameters addEntriesFromDictionary:@{@"auto": self.autoOrder,
                                               @"auto": self.autoOrder,
                                               @"good_info": [goodInfoArr mmh_JSONString],
                                               @"type": transferType}];
    } else {
        [parameters addEntriesFromDictionary:@{@"card_ids": self.cartItemIds, @"type": @"1"}];
    }
    
    return parameters;
}


@end

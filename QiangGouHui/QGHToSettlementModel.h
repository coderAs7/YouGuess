//
//  QGHToSettlementModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/12.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGHToSettlementModel : NSObject

@property (nonatomic, copy) NSString *receiptId;
@property (nonatomic, assign) float mailPrice;
@property (nonatomic, copy) NSString *autoOrder;
@property (nonatomic, assign) QGHBussType bussType;
@property (nonatomic, strong) NSArray *productArr;
@property (nonatomic, assign) float amount;
@property (nonatomic, copy) NSString *delivery;
@property (nonatomic, copy) NSString *production_time;

@property (nonatomic, copy) NSString *cartItemIds;

- (NSDictionary *)parameters;

@end

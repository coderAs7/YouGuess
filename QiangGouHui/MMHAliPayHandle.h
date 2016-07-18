//
//  MMHAliPayHandle.h
//  MamHao
//
//  Created by SmartMin on 15/5/26.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMHPayOrderModel.h"


@interface MMHAliPayHandle : NSObject

@property (nonatomic,copy)NSString *alipayOutTradeNo;

+ (void)goPayWithOrder:(MMHPayOrderModel *)payOrder;
+(MMHAliPayHandle *)alipayOrderNoShared;
//+ (NSString *)searchTargetWithString:(NSString *)string;

@end

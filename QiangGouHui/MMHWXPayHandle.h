//
//  MMHWXPayHandle.h
//  MamHao
//
//  Created by fishycx on 15/8/9.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"
//#import "MMHPayOrderModel.h"


//#define SP_URL  @"http://101.68.78.46:8889/gd-app-api/wxpay/build.do"
//#define SP_URL  @"http://api.mamhao.cn/wxpay/build.do"


@interface MMHWXPayHandle : NSObject<WXApiDelegate>
+ (MMHWXPayHandle *)wxPayHandle;
- (void)sendPayWithOrder:(NSString *)payOrder;
@end

//
//  MMHWeChatAdapter.h
//  MamHao
//
//  Created by Louis Zhu on 15/8/14.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WXApiObject.h"

#if TARGET_IPHONE_SIMULATOR
#define MMHWeChatResponse id
#else
#define MMHWeChatResponse BaseResp *
#endif


#if TARGET_IPHONE_SIMULATOR
#define MMHWeChatPayResponse id
#else
#define MMHWeChatPayResponse (PayResp *)
#endif


@interface MMHWeChatAdapter : NSObject

+ (void)start;

+ (BOOL)isWeChatInstalled;
+ (BOOL)shouldHandleOpenURL:(NSURL *)url;
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id<WXApiDelegate>)delegate;
@end


//@interface ShareSDK (MMHWeChatAdapter)
//
//+ (void)connectWeChat;
//
//@end

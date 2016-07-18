//
//  MMHWeChatAdapter.m
//  MamHao
//
//  Created by Louis Zhu on 15/8/14.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHWeChatAdapter.h"
#import "WXApi.h"
#import "AppDelegate.h"


@implementation MMHWeChatAdapter


+ (void)start {
#if TARGET_IPHONE_SIMULATOR
    
#else
    [WXApi registerApp:@"wx73ce0c7fa5af1828" withDescription:@"weixin"];
#endif
}


+ (BOOL)isWeChatInstalled {
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return [WXApi isWXAppInstalled];
#endif
}


+ (BOOL)shouldHandleOpenURL:(NSURL *)url {
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return ([url.scheme isEqualToString:@"wx73ce0c7fa5af1828"]);
#endif
}


+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id<WXApiDelegate>)delegate {
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return [WXApi handleOpenURL:url delegate:delegate];
#endif
}
@end


//@implementation ShareSDK (MMHWeChatAdapter)
//
//
//+ (void)connectWeChat {
//#if TARGET_IPHONE_SIMULATOR
//
//#else
//    [ShareSDK connectWeChatWithAppId:@"wxc8fc74797890d5d5"
//                           appSecret:@"bd65ce39ad42ce4a5b904f4228103eb2"
//                           wechatCls:[WXApi class]];
//#endif
//}
//
//
//@end
//
//  QGHConstants.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/29.
//  Copyright © 2016年 姚驰. All rights reserved.
//

#ifndef QGHConstants_h
#define QGHConstants_h

#import <Foundation/Foundation.h>

#define IS_IOS7_LATER   ([UIDevice currentDevice].systemVersion.floatValue > 6.99)
#define IS_IOS8_LATER   ([UIDevice currentDevice].systemVersion.floatValue > 7.99)

#pragma mark - Basics


#define kScreenBounds               [[UIScreen mainScreen] bounds]
#define kApplicationFrame           [[UIScreen mainScreen] applicationFrame]


#define kScreenScale                ([UIScreen instancesRespondToSelector:@selector(scale)]?[[UIScreen mainScreen] scale]:(1.0f))
#define kScreenWidth                ([[UIScreen mainScreen] applicationFrame].size.width)

#define kUserInterfaceIdiomIsPhone  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kUserInterfaceIdiomIsPad    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kScreenIs35InchRetina       (([UIScreen mainScreen].scale == 2.0f) && (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320.0f, 480.0f))))
#define kScreenIs4InchRetina        (([UIScreen mainScreen].scale == 2.0f) && (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320.0f, 568.0f))))
#define kScreenIs47InchRetina       (([UIScreen mainScreen].scale == 2.0f) && (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375.0f, 667.0f))))
#define kScreenIs55InchRetinaHD     (([UIScreen mainScreen].scale == 3.0f) && (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414.0f, 736.0f))))

#define ios7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define ios8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define ios6 ([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
#define ios5 ([[UIDevice currentDevice].systemVersion doubleValue] < 6.0)
#define iphone5  ([UIScreen mainScreen].bounds.size.height == 568)
#define iphone6  ([UIScreen mainScreen].bounds.size.height == 667)
#define iphone6Plus  ([UIScreen mainScreen].bounds.size.height == 736)
#define iphone4  ([UIScreen mainScreen].bounds.size.height == 480)
#define ipadMini2  ([UIScreen mainScreen].bounds.size.height == 1024)




#define SYSTEM_NUMBER [[[UIDevice currentDevice] systemVersion] floatValue]
#define kSystemVersion              [[UIDevice currentDevice] systemVersion]
#define kSystemVersionProiorToIOS6  ([kSystemVersion compare:@"6.0" options:NSNumericSearch range:NSMakeRange(0, 3)] == NSOrderedAscending)


#define kNoneNetworkReachable       ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)


static NSString *const MMHAlipayNotification = @"MMHAlipayNotification"; /**< 支付宝支付通知 */

//微信支付通知
static NSString *const MMHWeChatPayFinishedNotification = @"MMHWeChatPayFinishedNotification"; /**< 微信支付通知 */
static NSString *const MMHWeChatPayResponseKey = @"MMHWeChatPayResponseKey"; /**< 微信支付 response */


typedef NS_ENUM(NSInteger, MMHPayWay) {
    MMHPayWayAlipay,
    MMHPayWayWeixin,
};

#endif /* QGHConstants_h */

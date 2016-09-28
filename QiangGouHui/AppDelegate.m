//
//  AppDelegate.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/30.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "AppDelegate.h"
#import "QGHTabBarController.h"
#import "QGHLocationManager.h"
#import "MMHAccountSession.h"
#import "MMHWeChatAdapter.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#if !TARGET_IPHONE_SIMULATOR
#import "WXApi.h"
#endif
#import "WeiboSDK.h"
#import "AppDelegate+EaseMob.h"
#import <AlipaySDK/AlipaySDK.h>


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MMHWeChatAdapter start];
    [self shareSDKConnectApp];
    [MMHAccountSession start];
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    [self initPush:application launchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [QGHAppearance configureGlobalAppearancesWithWindow:self.window];
    QGHTabBarController *tabBarController = [[QGHTabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    
    if ([[MMHAccountSession currentSession] alreadyLoggedIn]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MMHUserDidLoginNotification object:nil];
    }
    
    return YES;
}


#pragma mark 初始化推送
- (void)initPush:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}


#pragma mark 处理本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //判断app是否在后台 然后处理一个本地通知
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive
        || [UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
//        [self handleLocalNotification:notification];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options {

    if ([MMHWeChatAdapter shouldHandleOpenURL:url]) {
        return [MMHWeChatAdapter handleOpenURL:url delegate:self];
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"safepay  result = %@",resultDic);
        }];
        
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"platformapi  result = %@",resultDic);
        }];
    }
    
    return YES;
}


- (void)shareSDKConnectApp {
    [ShareSDK registerApp:SHARESDK_APPID activePlatforms:@[@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeSinaWeibo)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
#if !TARGET_IPHONE_SIMULATOR
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
#endif
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:QQ_APPID appKey:QQ_APPKEY authType:SSDKAuthTypeBoth];
                break;
#if !TARGET_IPHONE_SIMULATOR
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:WECHAT_APPID appSecret:WECHAT_APPSECRET];
                break;
#endif
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:WEIBO_APPKEY
                                          appSecret:WEIBO_APPSECRET
                                        redirectUri:@"http://www.sharesdk.cn"
                                           authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}

#if !TARGET_IPHONE_SIMULATOR
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        if (response.errCode == WXSuccess) {
            //回调成功调接口
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MMHWeChatPayFinishedNotification object:nil userInfo:@{MMHWeChatPayResponseKey: resp}];
        
    }
}
#endif

@end

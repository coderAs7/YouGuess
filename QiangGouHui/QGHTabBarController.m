//
//  QGHTabBarController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/31.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHTabBarController.h"
#import "QGHFirstViewController.h"
#import "QGHChatViewController.h"
#import "QGHCartViewController.h"
#import "QGHPersonalCenterViewController.h"
#import "QGHNavigationController.h"
#import "AppDelegate.h"


@interface QGHTabBarController ()

@end

@implementation QGHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QGHFirstViewController *firstViewController = [[QGHFirstViewController alloc] init];
    firstViewController.title = @"首页";
    QGHNavigationController *firstVCNav = [[QGHNavigationController alloc] initWithRootViewController:firstViewController];
    
    QGHChatViewController *chatVC = [[QGHChatViewController alloc] init];
    chatVC.title = @"聊天";
    QGHNavigationController *chatVCNav = [[QGHNavigationController alloc] initWithRootViewController:chatVC];
    
    QGHCartViewController *cartVC = [[QGHCartViewController alloc] init];
    cartVC.title = @"购物车";
    QGHNavigationController *cartVCNav = [[QGHNavigationController alloc] initWithRootViewController:cartVC];
    
    QGHPersonalCenterViewController *personalCenterVC = [[QGHPersonalCenterViewController alloc] init];
    personalCenterVC.title = @"我的";
    QGHNavigationController *personalCenterVCNav = [[QGHNavigationController alloc] initWithRootViewController:personalCenterVC];
    
    self.viewControllers = @[firstVCNav, chatVCNav, cartVCNav, personalCenterVCNav];
}


+ (void)redirectToCenterWithController:(UIViewController *)controller {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    QGHTabBarController *tabBarController = (QGHTabBarController *)delegate.window.rootViewController;
    
    for (NSInteger i = 0; i < tabBarController.viewControllers.count; i++) {
        QGHNavigationController *navigationController = tabBarController.viewControllers[i];
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            if (i != QGHTabBarControllerViewControllerIndexPersonal) {
                [navigationController popToRootViewControllerAnimated:NO];
            }
        }
    }
    
    QGHNavigationController *personalCenterNavigationController = [tabBarController.viewControllers objectAtIndex:QGHTabBarControllerViewControllerIndexPersonal];
    
    QGHPersonalCenterViewController *personalViewController = personalCenterNavigationController.viewControllers.firstObject;
    personalViewController.hidesBottomBarWhenPushed = NO;
    controller.hidesBottomBarWhenPushed = YES;
    NSArray *finalMamhaoViewControllers = @[personalViewController, controller];
    [personalCenterNavigationController setViewControllers:finalMamhaoViewControllers animated:YES];
    
    [tabBarController setSelectedIndex:QGHTabBarControllerViewControllerIndexPersonal];
}


@end

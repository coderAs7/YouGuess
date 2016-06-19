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


@interface QGHTabBarController ()

@end

@implementation QGHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QGHFirstViewController *firstViewController = [[QGHFirstViewController alloc] init];
    firstViewController.title = @"首页";
    UINavigationController *firstVCNav = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    
    QGHChatViewController *chatVC = [[QGHChatViewController alloc] init];
    chatVC.title = @"聊天";
    UINavigationController *chatVCNav = [[UINavigationController alloc] initWithRootViewController:chatVC];
    
    QGHCartViewController *cartVC = [[QGHCartViewController alloc] init];
    cartVC.title = @"购物车";
    UINavigationController *cartVCNav = [[UINavigationController alloc] initWithRootViewController:cartVC];
    
    QGHPersonalCenterViewController *personalCenterVC = [[QGHPersonalCenterViewController alloc] init];
    personalCenterVC.title = @"我的";
    UINavigationController *personalCenterVCNav = [[UINavigationController alloc] initWithRootViewController:personalCenterVC];
    
    self.viewControllers = @[firstVCNav, chatVCNav, cartVCNav, personalCenterVCNav];
}


@end

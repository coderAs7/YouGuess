//
//  QGHTabBarController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/31.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHTabBarController.h"
#import "QGHFirstViewController.h"


@interface QGHTabBarController ()

@end

@implementation QGHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QGHFirstViewController *firstViewController = [[QGHFirstViewController alloc] init];
    UINavigationController *firstVCNav = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    self.viewControllers = @[firstVCNav];
}


@end

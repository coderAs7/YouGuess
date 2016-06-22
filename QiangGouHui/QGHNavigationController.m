//
//  QGHNavigationController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/22.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHNavigationController.h"
#import "BaseViewController.h"

@interface QGHNavigationController ()

@end

@implementation QGHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[BaseViewController class]]) {
        BaseViewController *abstractViewController = (BaseViewController *)viewController;
        if (self.viewControllers.count == 0) {
            abstractViewController.hidesBottomBarWhenPushed = NO;
        }
        else {
            abstractViewController.hidesBottomBarWhenPushed = YES;
        }
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}
@end

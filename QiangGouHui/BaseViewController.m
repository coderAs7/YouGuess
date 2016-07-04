//
//  BaseViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/30.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"
#import "QGHloginViewController.h"
#import "QGHRegisterViewController.h"


@interface BaseViewController ()

@end


@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [QGHAppearance backgroundColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone; //容器为navigationController时，默认布局将从屏幕最顶端开始，将此属性设为UIRectEdgeNone时，UI布局将从navigationBar下方开始
    self.modalPresentationCapturesStatusBarAppearance = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (self != [self.navigationController.viewControllers firstObject]) {
        [self setGoBackItemOnLeftBarButtonItem];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self.navigationController;
    }
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)setGoBackItemOnLeftBarButtonItem {
    UIBarButtonItem *goBackItem = [UIBarButtonItem itemWithImageName:@"basc_nav_back"
                                                highlightedImageName:nil
                                                               title:nil
                                                              target:self
                                                              action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItems = @[goBackItem];
}


- (void)popViewController
{
    if (self.navigationController) {
        UIBarButtonItem *item = [[self.navigationItem leftBarButtonItems] firstObject];
        item.enabled = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)presentLoginViewControllerWithSucceededHandler:(void(^)())succeededHandler
{
    QGHLoginViewController *loginViewController = [[QGHLoginViewController alloc] init];
    if (succeededHandler) {
        loginViewController.succeededHandler = ^(MMHAccount *account) {
            succeededHandler();
        };
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    if (self.navigationController != nil) {
        [self.navigationController presentViewController:navigationController animated:YES completion:^{
            
        }];
        
    } else {
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}


- (void)presentRegisterViewControllerWithSucceededHandler:(void(^)())succeededHandler {
    QGHRegisterViewController *registerViewController = [[QGHRegisterViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerViewController];
    if (self.navigationController != nil) {
        [self.navigationController presentViewController:navigationController animated:YES completion:^{
            
        }];
    } else {
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}


@end

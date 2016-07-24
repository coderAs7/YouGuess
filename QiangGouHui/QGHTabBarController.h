//
//  QGHTabBarController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/31.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMHFloatingViewController.h"
#import "MMHFloatingSettledViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, QGHTabBarControllerViewControllerIndex) {
    QGHTabBarControllerViewControllerIndexFirstPage,
    QGHTabBarControllerViewControllerIndexChat,
    QGHTabBarControllerViewControllerIndexCart,
    QGHTabBarControllerViewControllerIndexPersonal,
};

@interface QGHTabBarController : UITabBarController <MMHFloatingSettledViewController>

@property (nonatomic, strong, nullable) UIView *floatingBackgroundView;
@property (nonatomic, strong, nullable) MMHFloatingViewController *floatingViewController;

+ (void)redirectToCenterWithController:(UIViewController *)controller;
+ (void)redirectToCart;

@end

NS_ASSUME_NONNULL_END
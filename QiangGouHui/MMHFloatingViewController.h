//
//  MMHFloatingViewController.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/17.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSInteger, MMHFloatingViewControllerPresentMode) {
    MMHFloatingViewControllerPresentModeSlideUp,
    MMHFloatingViewControllerPresentModeSlideLeft,
    MMHFloatingViewControllerPresentModeFadeInCentered,
};


@protocol MMHFloatingSettledViewController;


@interface MMHFloatingViewController : BaseViewController

@property (nonatomic, weak) id <MMHFloatingSettledViewController> settledViewController;

- (CGSize)sizeWhileFloating;
- (MMHFloatingViewControllerPresentMode)presentMode;

@end

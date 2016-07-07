//
//  MMHFloatingSettledViewController.h
//  MamHao
//
//  Created by fishycx on 16/1/14.
//  Copyright © 2016年 Mamahao. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MMHFloatingViewController;


@protocol MMHFloatingSettledViewController <NSObject>

@property (nonatomic, strong, nullable) UIView *floatingBackgroundView;
@property (nonatomic, strong, nullable) MMHFloatingViewController *floatingViewController;
//@property (nonatomic, weak, nullable) UIViewController *launchADViewController;

- (void)presentFloatingViewController:(MMHFloatingViewController * __nonnull)viewController animated:(BOOL)animated;
- (void)dismissFloatingViewControllerAnimated:(BOOL)animated completion:(nullable void(^)())completion;

@end

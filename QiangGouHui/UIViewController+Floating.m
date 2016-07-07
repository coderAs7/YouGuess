//
//  UIViewController+Floating.m
//  MamHao
//
//  Created by fishycx on 16/1/14.
//  Copyright © 2016年 Mamahao. All rights reserved.
//

#import "UIViewController+Floating.h"
#import "MMHFloatingViewController.h"


@implementation UIViewController (Floating)


@dynamic floatingBackgroundView;
@dynamic floatingViewController;
//@dynamic launchADViewController;


- (void)presentFloatingViewController:(MMHFloatingViewController *)viewController animated:(BOOL)animated {
    if (self.floatingViewController != nil) {
        return;
    }
    
    self.floatingViewController = viewController;
    
    if (self.floatingBackgroundView == nil) {
        UIView *floatingBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        floatingBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        floatingBackgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(floatingBackgroundViewTapped:)];
        [floatingBackgroundView addGestureRecognizer:tapGestureRecognizer];
        [self.view addSubview:floatingBackgroundView];
        self.floatingBackgroundView = floatingBackgroundView;
    }
    self.floatingBackgroundView.alpha = 0.0f;
    
    CGRect startFrame = self.view.bounds;
    startFrame.size = [viewController sizeWhileFloating];
    switch (viewController.presentMode) {
        case MMHFloatingViewControllerPresentModeSlideUp: {
            startFrame.origin.y = CGRectGetMaxY(self.view.bounds);
            break;
        }
        case MMHFloatingViewControllerPresentModeSlideLeft: {
            startFrame.origin.x = CGRectGetMaxX(startFrame);
            break;
        }
        case MMHFloatingViewControllerPresentModeFadeInCentered: {
            startFrame.origin.x = (self.view.bounds.size.width - startFrame.size.width) * 0.5f;
            startFrame.origin.y = (self.view.bounds.size.height - startFrame.size.height) * 0.5f;
            
            viewController.view.alpha = 0.0f;
            break;
        }
        default:
            break;
    }
    viewController.view.frame = startFrame;
    
    if (animated) {
        __weak __typeof(self) weakSelf = self;
        [self addChildViewController:viewController];
        viewController.settledViewController = self;
        [self.view addSubview:viewController.view];
        [UIView animateWithDuration:0.25
                         animations:^{
                             weakSelf.floatingBackgroundView.alpha = 1.0f;
                             switch (viewController.presentMode) {
                                 case MMHFloatingViewControllerPresentModeSlideUp: {
                                     [viewController.view moveYOffset:([viewController sizeWhileFloating].height * (-1.0f))];
                                     break;
                                 }
                                 case MMHFloatingViewControllerPresentModeSlideLeft: {
                                     [viewController.view moveXOffset:([viewController sizeWhileFloating].width * (-1.0f))];
                                     break;
                                 }
                                 case MMHFloatingViewControllerPresentModeFadeInCentered: {
                                     viewController.view.alpha = 1.0f;
                                     break;
                                 }
                                 default:
                                     break;
                             }
                         } completion:^(BOOL finished) {
                             [viewController didMoveToParentViewController:weakSelf];
//                             if (self.launchADViewController) {
//                                 [self.launchADViewController.view bringToFront];
//                             }
                         }];
    }
    else {
        [self addChildViewController:viewController];
        viewController.settledViewController = self;
        [self.view addSubview:viewController.view];
        self.floatingBackgroundView.alpha = 1.0f;
        switch (viewController.presentMode) {
            case MMHFloatingViewControllerPresentModeSlideUp: {
                [viewController.view moveYOffset:([viewController sizeWhileFloating].height * (-1.0f))];
                break;
            }
            case MMHFloatingViewControllerPresentModeSlideLeft: {
                [viewController.view moveXOffset:([viewController sizeWhileFloating].width * (-1.0f))];
                break;
            }
            case MMHFloatingViewControllerPresentModeFadeInCentered: {
                viewController.view.alpha = 1.0f;
                break;
            }
            default:
                break;
        }
        [viewController didMoveToParentViewController:self];
//        if (self.launchADViewController) {
//            [self.launchADViewController.view bringToFront];
//        }
    }
}



- (void)floatingBackgroundViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self dismissFloatingViewControllerAnimated:YES completion:nil];
}


- (void)dismissFloatingViewControllerAnimated:(BOOL)animated completion:(void(^)())completion
{
    if (animated) {
        self.floatingViewController.settledViewController = nil;
        [self.floatingViewController willMoveToParentViewController:nil];
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.floatingBackgroundView.alpha = 0.0f;
                             switch (self.floatingViewController.presentMode) {
                                 case MMHFloatingViewControllerPresentModeSlideUp: {
                                     [self.floatingViewController.view moveYOffset:[self.floatingViewController sizeWhileFloating].height];
                                     break;
                                 }
                                 case MMHFloatingViewControllerPresentModeSlideLeft: {
                                     [self.floatingViewController.view moveXOffset:[self.floatingViewController sizeWhileFloating].width];
                                     break;
                                 }
                                 case MMHFloatingViewControllerPresentModeFadeInCentered: {
                                     self.floatingViewController.view.alpha = 0.0f;
                                     break;
                                 }
                                 default:
                                     break;
                             }
                         } completion:^(BOOL finished) {
                             [self.floatingViewController.view removeFromSuperview];
                             [self.floatingViewController removeFromParentViewController];
                             
                             if (completion) {
                                 completion();
                             }
                             
                             self.floatingBackgroundView = nil;
                             self.floatingViewController = nil;
                         }];
    }
    else {
        self.floatingViewController.settledViewController = nil;
        [self.floatingViewController willMoveToParentViewController:nil];
        [self.floatingViewController.view removeFromSuperview];
        [self.floatingViewController removeFromParentViewController];
        
        if (completion) {
            completion();
        }
        
        self.floatingBackgroundView = nil;
        self.floatingViewController = nil;
    }
}


@end

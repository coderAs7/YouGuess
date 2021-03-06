//
//  BaseViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/30.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)presentLoginViewControllerWithSucceededHandler:(void(^)())succeededHandler;
- (void)presentRegisterViewControllerWithSucceededHandler:(void(^)())succeededHandler;

@end

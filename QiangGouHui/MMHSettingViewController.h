//
//  MMHSettingViewController.h
//  MamHao
//
//  Created by fishycx on 15/5/23.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//
// 【设置】
#import "BaseViewController.h"

typedef void(^MMHSettingViewControllerLogOutCallback)();


@interface MMHSettingViewController : BaseViewController


@property (nonatomic, copy) MMHSettingViewControllerLogOutCallback callback;

@end

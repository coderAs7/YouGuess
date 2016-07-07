//
//  MMHFloatingViewController.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/17.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHFloatingViewController.h"


@implementation MMHFloatingViewController


- (CGSize)sizeWhileFloating
{
    return [[UIScreen mainScreen] applicationFrame].size;
}


- (MMHFloatingViewControllerPresentMode)presentMode
{
    return MMHFloatingViewControllerPresentModeSlideUp;
}


@end

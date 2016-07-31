//
//  EaseBubbleView+Custom.h
//  easydoctor
//
//  Created by 姚驰 on 16/7/5.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "EaseBubbleView.h"

@interface EaseBubbleView (Custom)

@property (nonatomic, strong) UIView *customView;

- (void)setupCustomView:(UIView *)view;
- (void)updateCustomViewMargin:(UIEdgeInsets)margin;

@end

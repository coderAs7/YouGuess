//
//  EaseBubbleView+Custom.m
//  easydoctor
//
//  Created by 姚驰 on 16/7/5.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "EaseBubbleView+Custom.h"
#import <objc/runtime.h>


static void *customViewPropertyKey = &customViewPropertyKey;


@implementation EaseBubbleView (Custom)


- (void)setCustomView:(UIView *)customView {
    objc_setAssociatedObject(self, customViewPropertyKey, customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)customView {
    return objc_getAssociatedObject(self, customViewPropertyKey);
}


#pragma mark -  private


- (void)_setupCustomViewBubbleConstraints {
    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    
    [self.marginConstraints removeAllObjects];
    [self.marginConstraints addObject:marginTopConstraint];
    [self.marginConstraints addObject:marginBottomConstraint];
    [self.marginConstraints addObject:marginLeftConstraint];
    [self.marginConstraints addObject:marginRightConstraint];
    
    [self addConstraints:self.marginConstraints];
}


#pragma mark - public


- (void)setupCustomView:(UIView *)view {
    self.customView = view;
    [self addSubview:view];
    
    [self _setupCustomViewBubbleConstraints];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
}


- (void)updateCustomViewMargin:(UIEdgeInsets)margin {
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupCustomViewBubbleConstraints];
}


@end

//
//  UIView+StringTag.h
//  MamHao
//
//  Created by SmartMin on 15/3/31.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface UIView (StringTag)

@property (nonatomic, strong) NSString *stringTag;

- (UIView *)viewWithStringTag:(NSString *)tag;

- (UIView *)findFirstResponder;

@end
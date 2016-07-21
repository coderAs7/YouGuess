//
//  MMHSortView.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/11.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MMHFilter;


@interface MMHSortView : UIView

@property (nonatomic, strong) MMHFilter *filter;

- (instancetype)initWithFrame:(CGRect)frame filter:(MMHFilter *)filter;
@end

//
//  MMHSortViewItem.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/15.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMHSort.h"


@class MMHFilter;


@interface MMHSortViewItem : UIView

@property (nonatomic) MMHSortType sortType;

@property (nonatomic, strong) MMHFilter *filter;

- (instancetype)initWithFrame:(CGRect)frame sortType:(MMHSortType)sortType filter:(MMHFilter *)filter;

- (void)updateViews;
@end

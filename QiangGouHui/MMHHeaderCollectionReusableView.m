//
//  MMHHeaderCollectionReusableView.m
//  MamHao
//
//  Created by fishycx on 15/5/19.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHHeaderCollectionReusableView.h"



@implementation MMHHeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect frame = CGRectMake(MMHFloat(15), 20, self.bounds.size.width, MMHFloat(14));
        self.title = [[UILabel alloc] initWithFrame:frame];
        _title.font = MMHFontOfSize(14);
        _title.textColor = [UIColor lightGrayColor];
        [self addSubview:_title];
       CGRect lineFrame = CGRectMake(0, CGRectGetMaxY(_title.frame) + 14.5, self.bounds.size.width, 0.5);
        UILabel *line = [[UILabel alloc] initWithFrame:lineFrame];
        self.line = line;
        line.backgroundColor = [QGHAppearance separatorColor];
        [self addSubview:line];
    }
    return self;
}

@end

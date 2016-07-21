//
//  MMHClassificationFooterView.m
//  MamHao
//
//  Created by fishycx on 15/5/21.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHClassificationFooterView.h"

@implementation MMHClassificationFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((self.bounds.size.width - MMHFloat(150)) / 2, 10, MMHFloat(150), 30);
        [btn setImage:[UIImage imageNamed:@"icon_delte"] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        btn.titleLabel.font = MMHFontOfSize(14);
        [btn setTitle:@"清空历史搜索" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(handleCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)handleCancelBtn:(UIButton *)sender{
    self.buttonAction(sender);
}
@end

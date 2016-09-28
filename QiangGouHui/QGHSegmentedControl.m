//
//  QGHSegmentedControl.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/20.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHSegmentedControl.h"


#define BUTTON_WIDTH 50
#define BUTTON_HEIGHT 24


@interface QGHSegmentedControl ()

@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, assign) NSInteger selectedIndex;

@end


@implementation QGHSegmentedControl

- (instancetype)initWithTitleArr:(NSArray *)arr {
    self = [super initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH * arr.count, BUTTON_HEIGHT)];
    
    if (self) {
        _buttonArr = [[NSMutableArray alloc] init];
        _selectedIndex = 0;
        
        for (NSInteger i = 0; i < arr.count; ++i) {
            NSString *title = arr[i];
            UIButton *button = [self makeButtonWithTitle:title];
            [button setX:BUTTON_WIDTH * i];
            if (i == 0) {
                button.selected = YES;
            }
            [self addSubview:button];
        }
    }
    
    return self;
}


- (UIButton *)makeButtonWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT)];
//    [button setBackgroundImage:[UIImage patternImageWithColor:[QGHAppearance themeColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage patternImageWithColor:RGBACOLOR(254, 237, 170, 0.65)] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage patternImageWithColor:RGBACOLOR(254, 237, 170, 0.65)] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = BUTTON_HEIGHT * 0.5;
    button.layer.masksToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:C21 forState:UIControlStateSelected];
    [button setTitleColor:[C21 colorWithAlphaComponent:0.65] forState:UIControlStateNormal];
    button.titleLabel.font = F6;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonArr addObject:button];
    
    return button;
}


- (void)buttonAction:(UIButton *)sender {
    UIButton *selectedButton = self.buttonArr[self.selectedIndex];
    selectedButton.selected = NO;
    
    NSInteger index = [self.buttonArr indexOfObject:sender];
    UIButton *willSelectButton = self.buttonArr[index];
    willSelectButton.selected = YES;
    
    self.selectedIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(segmentedControlDidSelected:)]) {
        [self.delegate segmentedControlDidSelected:index];
    }
}

@end

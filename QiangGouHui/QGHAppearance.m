//
//  QGHAppearance.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/30.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHAppearance.h"

UIFont *F0;
UIFont *F1;
UIFont *F2;
UIFont *F3;
UIFont *F4;
UIFont *F5;
UIFont *F6;
UIFont *F7;
UIFont *F8;
UIFont *F10;
UIFont *F13;


//UIColor *C0;
UIColor *C1;
UIColor *C2;
UIColor *C3;
UIColor *C4;
UIColor *C5;
UIColor *C6;
UIColor *C7;
UIColor *C8;

UIColor *C20;
UIColor *C21;
UIColor *C22;
UIColor *C23;
UIColor *C24;   //浅黄色
//UIColor *C24;
//UIColor *C25;
//UIColor *C26;


@implementation QGHAppearance

+ (void)configureGlobalAppearancesWithWindow:(UIWindow *)window
{
    F0 = [UIFont systemFontOfSize:10.0f];
    F1 = [UIFont systemFontOfSize:11.0f];
    F2 = [UIFont systemFontOfSize:12.0f];
    F3 = [UIFont systemFontOfSize:13.0f];
    F4 = [UIFont systemFontOfSize:14.0f];
    F5 = [UIFont systemFontOfSize:15.0f];
    F6 = [UIFont systemFontOfSize:16.0f];
    F7 = [UIFont systemFontOfSize:17.0f];
    F8 = [UIFont systemFontOfSize:18.0f];
    F10 = [UIFont systemFontOfSize:20.0f];
    F13 = [UIFont systemFontOfSize:23.0f];
    

//    C0 = [UIColor colorWithHexString:@"fafafa"];
    C1 = [UIColor colorWithHexString:@"ffffff"];
    C2 = [UIColor colorWithHexString:@"000000"];
    C3 = [UIColor colorWithHexString:@"f7f7f7"];
    C4 = [UIColor colorWithHexString:@"e7e7e7"];
    C5 = [UIColor colorWithHexString:@"cccccc"];
    C6 = [UIColor colorWithHexString:@"999999"];
    C7 = [UIColor colorWithHexString:@"666666"];
    C8 = [UIColor colorWithHexString:@"333333"];
    C20 = [UIColor colorWithHexString:@"ffcd00"];
    C21 = [UIColor colorWithHexString:@"6b450a"];
    C22 = [UIColor colorWithHexString:@"ff2640"];
    C23 = [UIColor colorWithHexString:@"ff7800"];
    C24 = RGBCOLOR(254, 204, 47);
//    C24 = [UIColor colorWithHexString:@"3bbc9c"];
//    C25 = [UIColor colorWithHexString:@"ff6c00"];
//    C26 = [UIColor colorWithRed:106 / 255.0 green:69 / 255.0 blue:18 / 255.0 alpha:1];
    
    [[UINavigationBar appearance] setTintColor:C6];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : F6, NSForegroundColorAttributeName: C8}];
    
    [[UIBarButtonItem appearance] setTintColor:C6];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : F4, NSForegroundColorAttributeName: C8} forState:UIControlStateNormal];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : C6 } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:254 / 255.0 green:204 / 255.0 blue:47 / 255.0 alpha:1] } forState:UIControlStateSelected];
    
}


@end


@implementation QGHAppearance (UIColorExtensions)


+ (UIColor *)backgroundColor {
    return [UIColor colorWithHexString:@"f0f0f0"];
}


+ (UIColor *)separatorColor {
    return [UIColor colorWithHexString:@"dcdcdc"];
}

+ (UIColor *)themeColor {
    return C20;
}

@end



@implementation MMHTitleLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.font = [QGHAppearance titleFont];
//        self.textColor = [QGHAppearance blackColor];
    }
    return self;
}


+ (CGFloat)defaultHeight
{
    return 18.0f;
}


@end


@implementation MMHSubtitleLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.font = [MMHAppearance subtitleFont];
//        self.textColor = [MMHAppearance blackColor];
    }
    return self;
}


+ (CGFloat)defaultHeight
{
    return 16.0f;
}


@end


@implementation MMHTextLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = F5;
        self.textColor = C8;
    }
    return self;
}


+ (CGFloat)defaultHeight
{
    return 15.0f;
}


@end


@implementation MMHSmallTextLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = F4;
        self.textColor = C7;
    }
    return self;
}


+ (CGFloat)defaultHeight
{
    return 14.0f;
}


@end


@implementation MMHTipsLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = F3;
        self.textColor = C6;
    }
    return self;
}


+ (CGFloat)defaultHeight
{
    return 13.0f;
}


@end


@implementation MMHSmallTipsLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = F2;
        self.textColor = C6;
    }
    return self;
}


+ (CGFloat)defaultHeight
{
    return 12.0f;
}


@end

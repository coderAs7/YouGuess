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


UIColor *C0;
UIColor *C1;
UIColor *C2;
UIColor *C3;
UIColor *C4;
UIColor *C5;
UIColor *C6;
UIColor *C7;

UIColor *C20;
UIColor *C21;
UIColor *C22;
UIColor *C23;
UIColor *C24;
UIColor *C25;


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
    

    C0 = [UIColor colorWithHexString:@"fafafa"];
    C1 = [UIColor colorWithHexString:@"f0f0f0"];
    C2 = [UIColor colorWithHexString:@"dcdcdc"];
    C3 = [UIColor colorWithHexString:@"cccccc"];
    C4 = [UIColor colorWithHexString:@"999999"];
    C5 = [UIColor colorWithHexString:@"666666"];
    C6 = [UIColor colorWithHexString:@"333333"];
    C7 = [UIColor colorWithHexString:@"000000"];
    C20 = [UIColor colorWithHexString:@"fc687c"];
    C21 = [UIColor colorWithHexString:@"ff4d61"];
    C22 = [UIColor colorWithHexString:@"477ed8"];
    C23 = [UIColor colorWithHexString:@"5cccccc"];
    C24 = [UIColor colorWithHexString:@"3bbc9c"];
    C25 = [UIColor colorWithHexString:@"ff6c00"];
    
    [[UINavigationBar appearance] setTintColor:C6];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:254 / 255.0 green:204 / 255.0 blue:47 / 255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : F6}];
    [[UIBarButtonItem appearance] setTintColor:C6];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : F5 } forState:UIControlStateNormal];
    
    [[UITabBar appearance] setBarTintColor:C0];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : C5 } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : C21 } forState:UIControlStateSelected];
    
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
    return [UIColor colorWithRed:254 / 255.0 green:204 / 255.0 blue:47 / 255.0 alpha:1];
}

@end

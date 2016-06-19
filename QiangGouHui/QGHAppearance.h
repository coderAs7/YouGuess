//
//  QGHAppearance.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/30.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <Foundation/Foundation.h>

extern UIFont *F0;
extern UIFont *F1;
extern UIFont *F2;
extern UIFont *F3;
extern UIFont *F4;
extern UIFont *F5;
extern UIFont *F6;
extern UIFont *F7;
extern UIFont *F8;
extern UIFont *F10;
extern UIFont *F13;


extern UIColor *C0;
extern UIColor *C1;
extern UIColor *C2;
extern UIColor *C3;
extern UIColor *C4;
extern UIColor *C5;
extern UIColor *C6;
extern UIColor *C7;

extern UIColor *C20;
extern UIColor *C21;
extern UIColor *C22;
extern UIColor *C23;
extern UIColor *C24;
extern UIColor *C25;
extern UIColor *C26;


@interface QGHAppearance : NSObject

+ (void)configureGlobalAppearancesWithWindow:(UIWindow *)window;

@end


@interface QGHAppearance (UIColorExtensions)

+ (UIColor *)backgroundColor;
+ (UIColor *)separatorColor;
+ (UIColor *)themeColor;

@end

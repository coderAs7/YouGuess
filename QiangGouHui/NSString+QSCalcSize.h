//
//  NSString+QSCalcSize.h
//  MamHao
//
//  Created by SmartMin on 15/3/31.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (QSCalcSize)

- (CGSize)sizeWithCalcFont:(UIFont *)font;

- (CGSize)sizeWithCalcFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end

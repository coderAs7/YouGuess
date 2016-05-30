//
//  NSString+QSCalcSize.m
//  MamHao
//
//  Created by SmartMin on 15/3/31.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "NSString+QSCalcSize.h"

@implementation NSString (QSCalcSize)

- (CGSize)sizeWithCalcFont:(UIFont *)font{
    
    CGSize calcSize = CGSizeZero;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (IS_IOS7_LATER) {
        calcSize = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    }else{
        calcSize = [self sizeWithFont:font];
    }
#pragma clang diagnostic pop
    return calcSize;
}

- (CGSize)sizeWithCalcFont:(UIFont *)font constrainedToSize:(CGSize)size{
    
    CGSize calcSize = CGSizeZero;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (IS_IOS7_LATER) {
        calcSize = [self boundingRectWithSize:size
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil].size;
    }else{
        calcSize = [self sizeWithFont:font constrainedToSize:size];
    }
#pragma clang diagnostic pop
    return calcSize;
}


@end

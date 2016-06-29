//
//  MMHDeleteLineLabel.m
//  MamHao
//
//  Created by SmartMin on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHDeleteLineLabel.h"

@implementation MMHDeleteLineLabel


-(void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
    
    CGSize textSize = [self.text sizeWithCalcFont:self.font];
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    CGFloat origin_x;
    CGFloat origin_y;
    
    if([self textAlignment] == NSTextAlignmentRight){
        origin_x = rect.size.width - strikeWidth;
    }else if ([self textAlignment] == NSTextAlignmentCenter) {
        origin_x = (rect.size.width - strikeWidth)/2 ;
    } else {
        origin_x = 0;
    }
    
    if (self.isUnderLine){              // 下划线
        origin_y = rect.size.height - 2;
    } else {                            // 删除线
        origin_y = rect.size.height / 2;
    }
    lineRect = CGRectMake(origin_x , origin_y, strikeWidth, 1);
    
    if (_strikeThroughEnabled == YES) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIColor *color = self.strikeThroughColor?:self.textColor;
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, lineRect);
    }
}

@end

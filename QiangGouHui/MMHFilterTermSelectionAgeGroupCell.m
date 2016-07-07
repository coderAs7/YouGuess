//
//  MMHFilterTermSelectionAgeGroupCell.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/13.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHFilterTermSelectionAgeGroupCell.h"
//#import "MMHFilter.h"
#import "QiangGouHui-Swift.h"


@interface MMHFilterTermSelectionAgeGroupCell ()

@end


@implementation MMHFilterTermSelectionAgeGroupCell


- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    if (enabled) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = C3.CGColor;
        self.layer.borderWidth = mmh_pixel();
        self.titleLabel.textColor = C5;
    }
    else {
        self.backgroundColor = C1;
        self.layer.borderColor = C1.CGColor;
        self.layer.borderWidth = 0;
        self.titleLabel.textColor = C3;
    }
}


//- (void)setTerm:(FilterTermAge *)term
//{
//    _term = term;
//
//    if (term == nil) {
//        self.titleLabel.text = @"";
//        self.selected = NO;
//    }
//    else {
//        [self.titleLabel setSingleLineText:term.name constrainedToWidth:CGFLOAT_MAX];
//        self.titleLabel.frame = self.bounds;
//    }
//}


//- (void)setTitle:(NSString *)title
//{
//    _title = title;
//    
//    if (title == nil) {
//        self.titleLabel.text = @"";
//        self.selected = NO;
//    }
//    else {
//        [self.titleLabel setSingleLineText:title constrainedToWidth:CGFLOAT_MAX];
//        self.titleLabel.frame = self.bounds;
//    }
//}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.0f;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 0.0f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [[self class] font];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"";
//        titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}


//+ (CGSize)sizeWithTerm:(FilterTermAge *)term
//{
//    NSString *name = term.name;
//    return [self sizeWithString:name];
//}


+ (UIFont *)font
{
    return [UIFont systemFontOfSize:mmh_relative_float(14.0f)];
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    if (!self.enabled) {
        return;
    }

    if (selected) {
        self.layer.borderColor = C21.CGColor;
        self.layer.borderWidth = 1.0f;
        self.titleLabel.textColor = C21;
    }
    else {
        self.layer.borderColor = C3.CGColor;
        self.layer.borderWidth = mmh_pixel();
        self.titleLabel.textColor = C5;
    }
}


+ (CGSize)sizeWithString:(NSString *)string
{
    CGSize stringSize = [string sizeWithSingleLineFont:[self font]];
    CGSize minSize = mmh_relative_size_make(90.0f, 28.0f);
    return CGSizeMake(MAX(stringSize.width, minSize.width), MAX(stringSize.height, minSize.height));
}
@end

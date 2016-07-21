//
//  MMHSearchCollectionViewCell.m
//  MamHao
//
//  Created by fishycx on 15/5/19.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHSearchCollectionViewCell.h"

@interface MMHSearchCollectionViewCell ()

@property (nonatomic, strong)UILabel *keyWordLabel;

@end

@implementation MMHSearchCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.keyWordLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _keyWordLabel.layer.cornerRadius = 15;
        _keyWordLabel.textAlignment = NSTextAlignmentCenter;
        _keyWordLabel.font = MMHFontOfSize(14);
        _keyWordLabel.textColor = [UIColor blackColor];
        UIColor *color =  [QGHAppearance separatorColor];
        _keyWordLabel.layer.borderColor = color.CGColor;
        _keyWordLabel.layer.borderWidth = 0.5;
        [self.contentView addSubview:_keyWordLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
 CGSize size =  [title sizeWithCalcFont:MMHFontOfSize(14) constrainedToSize:CGSizeMake(kScreenWidth, 30)];
    size.width+= MMHFloat(20);
    size.height = 30;
    CGRect frame  = self.keyWordLabel.frame;
    frame.size = size;
    self.keyWordLabel.frame = frame;
    self.keyWordLabel.text = title;
    
}

@end

//
//  MMHProductDetailPullDownHeaderView.m
//  MamHao
//
//  Created by YaoChi on 15/9/10.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHProductDetailPullDownHeaderView.h"

@interface MMHProductDetailPullDownHeaderView ()

@property (nonatomic, strong) UILabel *tipLbl;

@end

@implementation MMHProductDetailPullDownHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] init];
        self.imgView = imgView;
        [self addSubview:imgView];
        
        UILabel *tipLbl = [[UILabel alloc] init];
        tipLbl.textAlignment = NSTextAlignmentLeft;
        tipLbl.font = F3;
        tipLbl.textColor = C7;
        self.tipLbl = tipLbl;
        [self addSubview:tipLbl];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imgView sizeToFit];
    [self.imgView setCenterY:self.height * 0.5];
    [self.tipLbl setCenterY:self.imgView.centerY];
    CGFloat width = self.imgView.width + 5 + self.tipLbl.width;
    [self.imgView setX:(kScreenWidth - width) * 0.5];
    [self.tipLbl attachToRightSideOfView:self.imgView byDistance:5];
}

- (void)setTip:(NSString *)tip {
    _tip = tip;
    [_tipLbl setSingleLineText:tip];
    
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [_imgView setImage:image];
    
    [self setNeedsLayout];
}

@end

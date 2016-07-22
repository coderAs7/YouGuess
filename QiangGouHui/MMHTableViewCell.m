//
//  MMHTableViewCell.m
//  MamHao
//
//  Created by YaoChi on 15/11/25.
//  Copyright © 2015年 Mamahao. All rights reserved.
//

#import "MMHTableViewCell.h"

@interface MMHTableViewCell ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong, readwrite) UILabel *detailLabel;

@end

@implementation MMHTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 1;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mmh_ic_into"]];
        arrow.x = kScreenWidth - 10 - arrow.width;
        arrow.hidden = YES;
        [self.contentView addSubview:arrow];
        self.arrow = arrow;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.numberOfLines = 1;
        [self.contentView addSubview:detailLabel];
        self.detailLabel = detailLabel;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerY = self.height * 0.5;
    [self.titleLabel setMaxX:kScreenWidth - 10];
    [self.detailLabel attachToLeftSideOfView:self.arrow byDistance:10];
    
    self.arrow.centerY = self.height * 0.5;
    self.detailLabel.centerY = self.height * 0.5;
}

- (void)setShowArrow:(BOOL)showArrow {
    self.arrow.hidden = !showArrow;
}

@end

//
//  QGHCommonCellTableViewCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/18.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHCommonCellTableViewCell.h"


@interface QGHCommonCellTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end


@implementation QGHCommonCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLabel.textColor = C6;
    self.subTitleLabel.textColor = C5;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    self.subTitleLabel.text = subTitle;
}

- (void)setIsHiddenArrow:(BOOL)isHiddenArrow {
    self.arrow.hidden = isHiddenArrow;
}

@end

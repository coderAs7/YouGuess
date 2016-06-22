//
//  QGHCommonCellTableViewCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/18.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHCommonCellTableViewCell.h"


@interface QGHCommonCellTableViewCell()

@property (weak, nonatomic, readwrite) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic, readwrite) IBOutlet UIImageView *arrow;

@end


@implementation QGHCommonCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLabel.textColor = C8;
    self.subTitleLabel.textColor = C7;
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

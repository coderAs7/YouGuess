//
//  QGHOrderLogisticsInfoCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/26.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderLogisticsInfoCell.h"


@interface QGHOrderLogisticsInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *yellowPoint;
@property (weak, nonatomic) IBOutlet UILabel *logisticsInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsTimeLabel;

@end


@implementation QGHOrderLogisticsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.logisticsInfoLabel.font = F4;
    self.logisticsInfoLabel.textColor = C24;
    
    self.logisticsTimeLabel.font = F3;
    self.logisticsTimeLabel.textColor = C7;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(mmh_screen_width());
        make.bottom.equalTo(self.logisticsTimeLabel).offset(20);
    }];
}


@end

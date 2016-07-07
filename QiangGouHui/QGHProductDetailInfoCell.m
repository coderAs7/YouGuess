//
//  QGHProductDetailInfoCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/1.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductDetailInfoCell.h"


@interface QGHProductDetailInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end


@implementation QGHProductDetailInfoCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.desLabel.textColor = C6;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(mmh_screen_width());
        make.bottom.equalTo(self.desLabel).offset(15);
    }];
}


- (void)setData:(QGHProductDetailModel *)model {
    self.nameLabel.text = model.product.title;
    self.desLabel.text = model.product.sub_title;
}


@end

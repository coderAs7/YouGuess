//
//  QGHProductDetailPriceCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/26.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductDetailPriceCell.h"
#import "MMHDeleteLineLabel.h"


@interface QGHProductDetailPriceCell ()

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) MMHDeleteLineLabel *oldpriceLabel;
@property (nonatomic, strong) UILabel *customLabel;
@property (nonatomic, strong) UILabel *timeTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end


@implementation QGHProductDetailPriceCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:25];
        _priceLabel.textColor = RGBCOLOR(252, 72, 83);
        [self.contentView addSubview:_priceLabel];
        
        _oldpriceLabel = [[MMHDeleteLineLabel alloc] init];
        _oldpriceLabel.backgroundColor = [UIColor clearColor];
        _oldpriceLabel.textColor = C4;
        _oldpriceLabel.font = F2;
        _oldpriceLabel.strikeThroughEnabled = YES;
        _oldpriceLabel.strikeThroughColor = C4;
        [self.contentView addSubview:_oldpriceLabel];
        
        _customLabel = [[UILabel alloc] init];
        _customLabel.backgroundColor = C20;
        _customLabel.textColor = C21;
        _customLabel.font = F3;
        [self.contentView addSubview:_customLabel];
        
        _timeTitleLabel = [[UILabel alloc] init];
        _timeTitleLabel.textColor = C21;
        _timeTitleLabel.font = F3;
        [self.contentView addSubview:_timeTitleLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = RGBCOLOR(254, 239, 170);
        _timeLabel.font = F3;
        [self.contentView addSubview:_timeLabel];
    }
    
    return self;
}


- (void)setData:(QGHProductDetailModel *)model {
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.product.discount_price];
    [self.priceLabel sizeToFit];
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.contentView);
    }];
}


@end

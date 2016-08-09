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
@property (nonatomic, strong) UILabel *produceTime;

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
        _oldpriceLabel.textColor = C6;
        _oldpriceLabel.font = F2;
        _oldpriceLabel.strikeThroughEnabled = YES;
        _oldpriceLabel.strikeThroughColor = C6;
        [self.contentView addSubview:_oldpriceLabel];
        
        _customLabel = [[UILabel alloc] init];
        _customLabel.backgroundColor = C20;
        _customLabel.textColor = C21;
        _customLabel.font = F3;
        _customLabel.layer.cornerRadius = 4;
        _customLabel.layer.masksToBounds = YES;
        _customLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_customLabel];
        
        _timeTitleLabel = [[UILabel alloc] init];
        _timeTitleLabel.textColor = C21;
        _timeTitleLabel.font = F3;
//        _timeTitleLabel.text = @"距抢购结束仅剩";
        [self.contentView addSubview:_timeTitleLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = C21;
        _timeLabel.backgroundColor = RGBCOLOR(254, 239, 170);
        _timeLabel.font = F3;
        _timeLabel.layer.cornerRadius = 5;
        _timeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_timeLabel];
        
        
        _produceTime = [[UILabel alloc] init];
        _produceTime.textColor = C21;
        _produceTime.font = F5;
        [self.contentView addSubview:_produceTime];
        
        UIView *backYellow = [[UIView alloc] init];
        backYellow.backgroundColor = C20;
        [self.contentView addSubview:backYellow];
        [self.contentView sendSubviewToBack:backYellow];
        [backYellow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.contentView);
            make.width.mas_equalTo(120);
            make.right.mas_equalTo(0);
        }];
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
    
    self.oldpriceLabel.text = [NSString stringWithFormat:@"¥%@", model.product.original_price];
    [self.oldpriceLabel sizeToFit];
    [self.oldpriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(12.5);
        make.bottom.equalTo(self.priceLabel.mas_centerY).offset(-2.5);
    }];
    
    switch ([model.product.type integerValue]) {
        case QGHBussTypeNormal:
            self.customLabel.text = @"";
            self.customLabel.hidden = YES;
            self.produceTime.hidden = YES;
            self.timeTitleLabel.hidden = YES;
            self.timeLabel.hidden = YES;
            break;
        case QGHBussTypePurchase:
            self.customLabel.text = [NSString stringWithFormat:@"还剩%ld件", model.product.stock];
            self.customLabel.hidden = NO;
            self.produceTime.hidden = YES;
            self.timeTitleLabel.hidden = NO;
            self.timeTitleLabel.text = @"距抢购结束时间";
            self.timeLabel.hidden = NO;
            break;
        case QGHBussTypeAppoint:
            self.customLabel.text = [NSString stringWithFormat:@"%@人已预约", model.product.purchase_num];
            self.customLabel.hidden = NO;
            self.produceTime.hidden = YES;
            self.timeTitleLabel.hidden = NO;
            self.timeTitleLabel.text = @"距预约结束时间";
            self.timeLabel.hidden = NO;
            break;
        case QGHBussTypeCustom:
            self.customLabel.text = [NSString stringWithFormat:@"%@人已定制", model.product.purchase_num];
            self.customLabel.hidden = NO;
            self.produceTime.hidden = NO;
            self.timeTitleLabel.hidden = YES;
            self.timeLabel.hidden = YES;
            break;
        default:
            break;
    }
//    self.customLabel.text = @"99人已预约";
    [self.customLabel sizeToFit];
    CGFloat width = [self.customLabel.text sizeWithFont:self.customLabel.font constrainedToWidth:CGFLOAT_MAX lineCount:1].width;
    [self.customLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.oldpriceLabel.mas_left);
        make.top.equalTo(self.oldpriceLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(width + 8);
    }];
    
    [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(-2.5);
    }];
    
    
    self.timeLabel.text = [self remainingDay:model.product.end_time];
    CGFloat timeLabelWidth = [self.timeLabel.text sizeWithFont:self.timeLabel.font constrainedToWidth:CGFLOAT_MAX lineCount:1].width;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeTitleLabel);
        make.top.mas_equalTo(self.contentView.mas_centerY).offset(2.5);
        make.width.mas_equalTo(timeLabelWidth + 8);
    }];
    
    self.produceTime.text = [NSString stringWithFormat:@"生产周期%@天", model.product.production_time];
    [self.produceTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-15);
    }];
}


- (NSString *)remainingDay:(double)endTime {
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSTimeInterval remainingSec = [endDate timeIntervalSinceDate:[NSDate date]];
    
    NSString *remainingStr = nil;
    if (remainingSec > 3600 * 24) {
        NSInteger day = remainingSec / (3600 * 24);
        remainingStr = [NSString stringWithFormat:@"%ld天", day];
    } else {
        NSInteger hour = remainingSec / 3600;
        NSInteger minute = ((NSInteger)remainingSec % 3600) / 60;
        
        remainingStr = [NSString stringWithFormat:@"%ld:%ld", hour, minute];
    }
    
    return remainingStr;
}

@end

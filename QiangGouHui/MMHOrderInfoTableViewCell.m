//
//  MMHOrderInfoTableViewCell.m
//  MamHao
//
//  Created by SmartMin on 15/4/28.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHOrderInfoTableViewCell.h"

@implementation MMHOrderInfoTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}


#pragma mark 创建view


- (void)createView{
    
    CGSize contentOfSize = [@"内容" sizeWithCalcFont:F3 constrainedToSize:CGSizeMake(kScreenBounds.size.width - 2 *MMHFloat(11), CGFLOAT_MAX)];
    self.orderNumberLabel = [[UILabel alloc] init];
    self.orderNumberLabel.backgroundColor = [UIColor clearColor];
    self.orderNumberLabel.font = F3;
    self.orderNumberLabel.frame = CGRectMake(MMHFloat(10), 18, kScreenBounds.size.width - 2 *MMHFloat(10), contentOfSize.height);
    self.orderNumberLabel.textColor = C6;
    [self addSubview: self.orderNumberLabel];
    
    // 下单时间
    self.orderingTimeLabel = [[UILabel alloc] init];
    self.orderingTimeLabel.backgroundColor = [UIColor clearColor];
    self.orderingTimeLabel.font = F3;
    self.orderingTimeLabel.frame = CGRectMake(MMHFloat(10), CGRectGetMaxY(self.orderNumberLabel.frame) + 5,kScreenBounds.size.width - 2 *MMHFloat(10), contentOfSize.height);
    self.orderingTimeLabel.textColor = C6;
    [self addSubview:self.orderingTimeLabel];
    
    
    self.orderStateLabel = [[UILabel alloc] init];
    self.orderStateLabel.font=F3;
    self.orderStateLabel.frame=CGRectMake( MMHFloat(10), CGRectGetMaxY(self.orderingTimeLabel.frame) + 5, self.orderingTimeLabel.frame.size.width,contentOfSize.height);
    self.orderStateLabel.textAlignment = NSTextAlignmentLeft;
    self.orderStateLabel.numberOfLines = 1;
    self.orderStateLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:self.orderStateLabel];
    
    self.cloudPickShopNameLabel = [[UILabel alloc] init];
    _cloudPickShopNameLabel.font = F3;
    _cloudPickShopNameLabel.textColor = C6;
    _cloudPickShopNameLabel.textAlignment = NSTextAlignmentLeft;
    _cloudPickShopNameLabel.numberOfLines = 1;
    _cloudPickShopNameLabel.frame = CGRectMake(MMHFloat(10), CGRectGetMaxY(self.orderStateLabel.frame)+5, kScreenWidth-2*MMHFloat(10), self.orderStateLabel.height);
    [self addSubview:self.cloudPickShopNameLabel];
    
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.font = F3;
    self.hintLabel.textColor = C6;
    self.hintLabel.frame = CGRectMake(MMHFloat(10), CGRectGetMaxY(self.cloudPickShopNameLabel.frame)+5, kScreenWidth-2*MMHFloat(10), self.orderStateLabel.height);
    self.hintLabel.numberOfLines = 2;
    [self addSubview:self.hintLabel];
    
    
}


// 下单时间
- (void)setOrderingTime:(NSString *)orderingTime {
    self.orderingTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",orderingTime];
}


// 订单编号
- (void)setOrderNumber:(NSString *)orderNumber {
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号:%@",orderNumber];
}


// 订单状态
- (void)setOrderState:(NSString *)orderState {
    NSString *string = [NSString stringWithFormat:@"订单状态:%@",orderState];
    NSRange range1 = [string rangeOfString:@"订单状态:"];
    NSRange range2 = [string rangeOfString:[NSString stringWithFormat:@"%@",orderState]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:C6 range:range1];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(252, 43, 70) range:range2];
    self.orderStateLabel.attributedText = str;
}


- (void)setHint:(NSString *)hint {
    if (self.cloudPickShopName.length == 0) {
        self.hintLabel.top = CGRectGetHeight(self.orderStateLabel.frame) + 5;
        self.cloudPickShopNameLabel.height = 0;
        self.cloudPickShopNameLabel.hidden = YES;
    }
    self.hintLabel.text = hint;
    CGSize size = [hint sizeWithCalcFont:F3 constrainedToSize:CGSizeMake(kScreenWidth - 10, CGFLOAT_MAX)];
    self.hintLabel.height = size.height;
}

- (void)setCloudPickShopName:(NSString *)cloudPickShopName {
    _cloudPickShopName = cloudPickShopName;
    [self.cloudPickShopNameLabel setSingleLineText:[NSString stringWithFormat:@"订单来源:%@",cloudPickShopName]];
}

//+ (CGFloat)cellHeightWithorderDetailModel:(MMHOrderDetailModel *)orderDetailModel {
//     CGSize contentOfSize = [@"内容" sizeWithCalcFont:F5 constrainedToSize:CGSizeMake(kScreenBounds.size.width - 2 *MMHFloat(11), CGFLOAT_MAX)];
//    CGFloat height = 18 * 2 + (contentOfSize.height + 5) * 2 + contentOfSize.height;
//    if (orderDetailModel.hint.length != 0) {
//        height += contentOfSize.height + 5;
//    }
//    if (orderDetailModel.pickShopName.length != 0) {
//        height += contentOfSize.height + 5;
//    }
//    return height;
//}


@end

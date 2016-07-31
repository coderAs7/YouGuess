//
//  MMHPersonalCenterAllOrderCell.m
//  MamHao
//
//  Created by YaoChi on 16/1/4.
//  Copyright © 2016年 Mamahao. All rights reserved.
//

#import "MMHPersonalCenterAllOrderCell.h"
#import "QGHOrderNumModel.h"


@interface MMHPersonalCenterAllOrderCellButton ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *badge;

@end

@implementation MMHPersonalCenterAllOrderCellButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *icon = [[UIImageView alloc] init];
        [self addSubview:icon];
        self.icon = icon;
        
        UILabel *title = [[UILabel alloc] init];
        title.font = F2;
        title.textColor = C6;
        [self addSubview:title];
        self.title = title;
        
        UILabel *badge = [[UILabel alloc] init];
        badge.textAlignment = NSTextAlignmentCenter;
        badge.font = [UIFont systemFontOfSize:9.0];
        badge.textColor = [UIColor whiteColor];
        badge.backgroundColor = C22;
        badge.layer.cornerRadius = 6;
        badge.layer.masksToBounds = YES;
        [self addSubview:badge];
        self.badge = badge;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imageAndTitleHeight = self.icon.height + 5 + self.title.height;
    
    self.icon.y = (self.height - imageAndTitleHeight) * 0.5;
    self.icon.centerX = self.width * 0.5;
    
    self.title.y = self.icon.bottom + 5;
    self.title.centerX = self.icon.centerX;
    
    self.badge.center = CGPointMake(self.icon.right, self.icon.top);
}

- (void)setImageName:(NSString *)imageName {
    self.icon.image = [UIImage imageNamed:imageName];
    [self.icon sizeToFit];
}

- (void)setTitleText:(NSString *)titleText {
    [self.title setSingleLineText:titleText];
}

- (void)setBadgeCount:(NSInteger)badgeCount {
    [self.badge setSingleLineText:[NSString stringWithFormat:@"%ld", (long)badgeCount]];
    if (badgeCount > 0) {
        self.badge.hidden = NO;
        if (badgeCount > 9 && badgeCount < 100) {
            self.badge.width = 17;
        } else {
            self.badge.width = 12;
        }
    } else {
        self.badge.hidden = YES;
    }
    [self setNeedsLayout];
}

@end





@interface MMHPersonalCenterAllOrderCell ()

@property (nonatomic, strong) NSArray<MMHPersonalCenterAllOrderCellButton *> *buttons;

@end

@implementation MMHPersonalCenterAllOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:5];
        NSArray *buttonImageNames = @[@"center_icon_obligation", @"", @"center_icon_fahuo", @"center_icon_evaluation", @"center_icon_return"];
        NSArray *buttonTitles = @[@"待付款",@"待发货", @"待收货", @"待评价", @"退款/售后"];
        
        CGFloat buttonWidth = mmh_screen_width() / 5;
        for (int i = 0; i < buttonImageNames.count; ++i) {
            MMHPersonalCenterAllOrderCellButton *button = [[MMHPersonalCenterAllOrderCellButton alloc] initWithFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, 70)];
            button.imageName = buttonImageNames[i];
            button.titleText = buttonTitles[i];
            [button addTarget:self action:@selector(buttonHandle:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [buttons addObject:button];
        }
        
        self.buttons = buttons;
    }
    
    return self;
}

//- (void)updateWithPersonalCenterInfoModel:(MMHPersonalCenterInfoModel *)model {
//    self.buttons[0].badgeCount = model.waitPayOrderCount.integerValue;
//    self.buttons[1].badgeCount = model.waitDeliverOrderCount.integerValue;
//    self.buttons[2].badgeCount = model.waitReceiveOrderCount.integerValue;
//    self.buttons[3].badgeCount = model.waitCommentOrderCount.integerValue;
//    self.buttons[4].badgeCount = model.refundOrderCount.integerValue;
//}

- (void)buttonHandle:(MMHPersonalCenterAllOrderCellButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickPersonalCenterAllOrderCellButton:)]) {
        NSInteger index = [self.buttons indexOfObject:sender];
        [self.delegate didClickPersonalCenterAllOrderCellButton:index];
    }
}


- (void)updateOrderNumModel:(QGHOrderNumModel *)model {
    self.buttons[0].badgeCount = model.waitpay;
    self.buttons[1].badgeCount = model.delivery;
    self.buttons[2].badgeCount = model.receipt;
    self.buttons[3].badgeCount = model.score;
    self.buttons[4].badgeCount = model.refund;
}


@end
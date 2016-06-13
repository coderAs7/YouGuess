//
//  QGHRushPurchaseItemView.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHRushPurchaseItemView.h"


@interface QGHRushPurchaseItemView ()

@property (nonatomic, strong) MMHImageView *itemImg;
@property (weak, nonatomic) IBOutlet UIView *itemImgBackView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oriPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation QGHRushPurchaseItemView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _itemImg = [[MMHImageView alloc] init];
    [self.itemImgBackView addSubview:_itemImg];
    
    [_itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.itemImgBackView);
        make.left.and.top.mas_equalTo(0);
    }];
    
    [self.numLabel bringToFront];
    self.numLabel.textColor = C0;
    self.numLabel.backgroundColor = [C2 colorWithAlphaComponent:0.65];
    
    self.priceLabel.textColor = C22;
    
    self.oriPriceLabel.textColor = C6;
    
    self.leftNumLabel.textColor = C6;
    
    self.nameLabel.textColor = [UIColor blackColor];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
    }
    
    return self;
}


@end

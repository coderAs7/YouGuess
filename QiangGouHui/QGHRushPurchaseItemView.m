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

@property (nonatomic, strong) QGHFirstPageGoodsModel *goods;
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
    self.numLabel.textColor = C1;
    self.numLabel.backgroundColor = [C2 colorWithAlphaComponent:0.65];
    
    self.priceLabel.textColor = C22;
    
    self.oriPriceLabel.textColor = C6;
    
    self.leftNumLabel.textColor = C6;
    
    self.nameLabel.textColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}


- (void)setGoodsModel:(QGHFirstPageGoodsModel *)goods {
    self.goods = goods;
    
    [self.itemImg updateViewWithImageAtURL:goods.img_path];
    self.numLabel.text = [NSString stringWithFormat:@"剩%ld件", goods.stock];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%g", goods.discount_price];
    self.oriPriceLabel.text = [NSString stringWithFormat:@"¥%g", goods.original_price];
    [self.oriPriceLabel addStrikethroughLine];
    self.leftNumLabel.text = [self remainingDay:goods.end_time];
    self.nameLabel.text = goods.title;
}


- (NSString *)remainingDay:(double)endTime {
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSTimeInterval remainingSec = [endDate timeIntervalSinceDate:[NSDate date]];
    
    NSString *remainingStr = nil;
    if (remainingSec > 3600 * 24) {
        NSInteger day = remainingSec / (3600 * 24);
        remainingStr = [NSString stringWithFormat:@"剩%ld天", day];
    } else {
        NSInteger hour = remainingSec / 3600;
        NSInteger minute = ((NSInteger)remainingSec % 3600) / 60;
        
        remainingStr = [NSString stringWithFormat:@"剩%ld:%ld", hour, minute];
    }
    
    return remainingStr;
}


- (void)tapAction {
    if ([self.delegate respondsToSelector:@selector(purchaseItemDidSelect:)]) {
        [self.delegate purchaseItemDidSelect:self.goods];
    }
}


@end

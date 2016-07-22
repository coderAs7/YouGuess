//
//  QGHProductListCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/21.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductListCell.h"
#import "QGHFirstPageGoodsModel.h"


@interface QGHProductListCell()

@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oriPriceLabel;
@property (nonatomic, strong) MMHImageView *productImageView;

@end


@implementation QGHProductListCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageBackView.backgroundColor = [UIColor clearColor];
    
    self.productImageView = [[MMHImageView alloc] init];
    [self.imageBackView addSubview:self.productImageView];
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.imageBackView.mas_width);
        make.height.equalTo(self.imageBackView.mas_height);
        make.center.equalTo(self.imageBackView);
    }];
    
    self.titleLabel.textColor = C8;
    self.priceLabel.textColor = C22;
    self.oriPriceLabel.textColor = C6;
}


- (void)setGoods:(QGHFirstPageGoodsModel *)goods {
    [self.productImageView updateViewWithImageAtURL:goods.img_path];
    self.titleLabel.text = goods.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%g", goods.discount_price];
    self.oriPriceLabel.text = [NSString stringWithFormat:@"¥%g", goods.original_price];
    [self.oriPriceLabel addStrikethroughLine];
}


@end

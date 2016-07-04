//
//  QGHGoodsTableViewCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/12.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHGoodsTableViewCell.h"


@interface QGHGoodsTableViewCell()

@property (nonatomic, strong) MMHImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UIView *goodsImgBackView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;

@end


@implementation QGHGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _goodsImg = [[MMHImageView alloc] init];
    [self.goodsImgBackView addSubview:_goodsImg];
    [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.goodsImgBackView);
        make.width.equalTo(self.goodsImgBackView);
        make.left.and.top.mas_equalTo(0);
    }];
    
    self.nameLabel.textColor = [UIColor blackColor];
    
    self.desLabel.textColor = C6;
    
    self.priceLabel.textColor = C22;
    
    self.separator.backgroundColor = [QGHAppearance backgroundColor];
}

- (void)setGoodsModel:(QGHFirstPageGoodsModel *)model {
    [self.goodsImg updateViewWithImageAtURL:model.img_path];
    self.nameLabel.text = model.title;
    self.desLabel.text = model.sub_title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%ld", (long)model.original_price];
}


@end

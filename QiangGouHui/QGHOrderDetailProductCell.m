//
//  QGHOrderDetailProductCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/26.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderDetailProductCell.h"
#import "QGHProductDetailModel.h"
#import "QGHCartItem.h"


@interface QGHOrderDetailProductCell ()

@property (weak, nonatomic) IBOutlet UIView *productBackView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (nonatomic, strong) MMHImageView *productImage;

@end


@implementation QGHOrderDetailProductCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.productBackView.backgroundColor = [UIColor clearColor];
    
    _productImage = [[MMHImageView alloc] init];
    _productImage.layer.cornerRadius = 3;
    _productImage.layer.borderWidth = 1;
    _productImage.layer.borderColor = [QGHAppearance separatorColor].CGColor;
    _productImage.layer.masksToBounds = YES;
    [self.productBackView addSubview:_productImage];
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.productBackView);
        make.center.equalTo(self.productBackView);
    }];
    
    self.priceLabel.textColor = RGBCOLOR(252, 43, 70);
}


- (void)setProductDetailModel:(QGHProductDetailModel *)productDetailModel {
    [self.productImage updateViewWithImageAtURL:productDetailModel.product.img_path];
    self.nameLabel.text = productDetailModel.product.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", productDetailModel.product.min_price];
    self.colorLabel.text = @"";
    self.sizeLabel.text = @"";
    self.numLabel.text = [NSString stringWithFormat:@"x%ld", productDetailModel.skuSelectModel.count];
}


- (void)setCartItem:(QGHCartItem *)cartItem {
    [self.productImage updateViewWithImageAtURL:cartItem.img_path];
    self.nameLabel.text = cartItem.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%g", cartItem.min_price];
    self.colorLabel.text = cartItem.sku;
    self.sizeLabel.text = @"";
    self.numLabel.text = [NSString stringWithFormat:@"x%d", cartItem.count];
}


@end

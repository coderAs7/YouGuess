//
//  QGHOrderDetailProductCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/26.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderDetailProductCell.h"


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


@end

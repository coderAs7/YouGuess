//
//  QGHOrderListCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/25.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderListCell.h"
#import "QGHOrderListItem.h"


@interface QGHOrderListCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *productBackView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (nonatomic, strong) MMHImageView *productImage;
@property (nonatomic, strong) UILabel *imageLabel;

@end


@implementation QGHOrderListCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.orderStatusLabel.textColor = RGBCOLOR(252, 43, 70);
    
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
    
    _imageLabel = [[UILabel alloc] init];
    _imageLabel.textColor = [UIColor whiteColor];
    _imageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _imageLabel.textAlignment = NSTextAlignmentCenter;
    [_productImage addSubview:_imageLabel];
    [_imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    self.button1.backgroundColor = C20;
    self.button1.layer.cornerRadius = 5;
    [self.button1 setTitleColor:C21 forState:UIControlStateNormal];
    [self.button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    
    self.button2.backgroundColor = C20;
    self.button2.layer.cornerRadius = 5;
    [self.button2 setTitleColor:C21 forState:UIControlStateNormal];
}


- (void)button1Action {
    if ([self.delegate respondsToSelector:@selector(orderListCellDidClickButton1:)]) {
        [self.delegate orderListCellDidClickButton1:self];
    }
}


@end

//
//  QGHCartCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/2.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHCartCell.h"
#import "QiangGouHui-Swift.h"
#import "MMHNetworkAdapter+Cart.h"


@interface QGHCartCell ()<StepperDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *checkImage;
@property (weak, nonatomic) IBOutlet UIView *productBackView;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) MMHImageView *productImage;
@property (nonatomic, strong) Stepper *stepper;

@end


@implementation QGHCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.checkImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.checkImage addGestureRecognizer:tap];
    
    self.productBackView.backgroundColor = [UIColor clearColor];
    
    _productImage = [[MMHImageView alloc] init];
    _productImage.layer.cornerRadius = 5;
    _productImage.layer.borderWidth = 0.5;
    _productImage.layer.borderColor = [QGHAppearance separatorColor].CGColor;
    [self.productBackView addSubview:_productImage];
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.productBackView);
        make.center.equalTo(self.productBackView);
    }];
    
    
    self.productTitle.textColor = C8;
    
    self.colorLabel.textColor = C6;
    
    self.sizeLabel.textColor = C6;
    
    self.priceLabel.textColor = RGBCOLOR(252, 43, 70);
    
    self.deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.deleteButton setTitleColor:C6 forState:UIControlStateNormal];
    self.deleteButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(55);
    }];
    
    _stepper = [[Stepper alloc] initWithFrame:CGRectMake(0, 0, 82.5, 22) minimumValue:1 maximumValue:NSIntegerMax value:1];
    [_stepper setDecreaseButtonImage:[UIImage imageNamed:@"cart_icon_shopping_reduce_n"] forState:UIControlStateNormal];
    [_stepper setDecreaseButtonImage:[UIImage imageNamed:@"cart_icon_shopping_reduce_d"] forState:UIControlStateDisabled];
    [_stepper setIncreaseButtonImage:[UIImage imageNamed:@"cart_icon_shopping_add_n"] forState:UIControlStateNormal];
    _stepper.layer.cornerRadius = 5;
    _stepper.delegate = self;
    [self.contentView addSubview:_stepper];
 
    [_stepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productBackView.mas_right).offset(15);
        make.bottom.equalTo(self.productBackView);
        make.width.mas_equalTo(82.5);
        make.height.mas_equalTo(22);
    }];
}


- (void)setCartItem:(QGHCartItem *)item {
    _cartItem = item;
    
    [self.productImage updateViewWithImageAtURL:item.img_path];
    self.productTitle.text = item.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%g", item.min_price];
    [self.colorLabel setSingleLineText:item.sku];
    self.sizeLabel.text = @"";
    self.stepper.value = item.count;
    if (item.isSelected) {
        self.checkImage.image = [UIImage imageNamed:@"dizhi_xuanzhong"];
    } else {
        self.checkImage.image = [UIImage imageNamed:@"dizhi_weixuanzhong"];
    }
}


#pragma mark - StepperDelegate


- (BOOL)stepper:(Stepper * __nonnull)stepper shouldChangeValueFrom:(NSInteger)currentValue to:(NSInteger)newValue
{
    if ([self.delegate respondsToSelector:@selector(cartCellModifyCount:changeValueFrom:to:)]) {
        [self.delegate cartCellModifyCount:self changeValueFrom:currentValue to:newValue];
    }
    
    return NO;
}


#pragma mark - Action


- (void)deleteButtonAction {
    if ([self.delegate respondsToSelector:@selector(cartCellDeleteItem:)]) {
        [self.delegate cartCellDeleteItem:self];
    }
}


- (void)tap {
    self.cartItem.isSelected = !self.cartItem.isSelected;
    if (self.cartItem.isSelected) {
        self.checkImage.image = [UIImage imageNamed:@"dizhi_xuanzhong"];
    } else {
        self.checkImage.image = [UIImage imageNamed:@"dizhi_weixuanzhong"];
    }
    
    if ([self.delegate respondsToSelector:@selector(cartCellSelectItem:)]) {
        [self.delegate cartCellSelectItem:self];
    }
}


@end

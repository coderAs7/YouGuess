//
//  QGHReceiptAddressCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/23.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHReceiptAddressCell.h"


@interface QGHReceiptAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *receiptName;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImage;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *delImage;
@property (weak, nonatomic) IBOutlet UILabel *delLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editImage;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;


@end


@implementation QGHReceiptAddressCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.receiptName.textColor = C8;
    self.phoneLabel.textColor = C8;
    self.addressLabel.textColor = C6;
    self.separator.backgroundColor = [QGHAppearance separatorColor];
    self.defaultLabel.textColor = C6;
    self.delLabel.textColor = C8;
    self.editLabel.textColor = C8;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(mmh_screen_width());
        make.bottom.equalTo(self.defaultImage).offset(15);
    }];
    
    self.defaultImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *defaultTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(defaultButtonAction)];
    [self.defaultImage addGestureRecognizer:defaultTap];
    
    self.delImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteButtonAction)];
    [self.delImage addGestureRecognizer:deleteTap];
    
    self.editImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editButtonAction)];
    [self.editImage addGestureRecognizer:editTap];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.checkImage.hidden = !self.isSelected;
}


- (void)setReceiptAddressModel:(QGHReceiptAddressModel *)model {
    _receiptAddressModel = model;
    
    self.receiptName.text = [NSString stringWithFormat:@"收货人：%@", model.username];
    self.phoneLabel.text = model.phone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", model.province, model.city, model.area, model.address];
    if ([model.isdefault isEqualToString:@"1"]) {
        self.defaultImage.image = [UIImage imageNamed:@"dizhi_xuanzhong"];
    } else {
        self.defaultImage.image = [UIImage imageNamed:@"dizhi_weixuanzhong"];
    }
}


- (void)defaultButtonAction {
    if ([self.delegate respondsToSelector:@selector(receiptAddressCellSetDefaultAddress:)]) {
        [self.delegate receiptAddressCellSetDefaultAddress:self];
    }
}


- (void)deleteButtonAction {
    if ([self.delegate respondsToSelector:@selector(receiptAddressCellDeleteAddress:)]) {
        [self.delegate receiptAddressCellDeleteAddress:self];
    }
}


- (void)editButtonAction {
    if ([self.delegate respondsToSelector:@selector(receiptAddressCellEditAddress:)]) {
        [self.delegate receiptAddressCellEditAddress:self];
    }
}


@end

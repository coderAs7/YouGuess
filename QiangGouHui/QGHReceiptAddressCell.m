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


- (void)defaultButtonAction {

}


- (void)deleteButtonAction {

}


- (void)editButtonAction {

}


@end

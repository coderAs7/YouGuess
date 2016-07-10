//
//  QGHOrderAddressCellTableViewCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/25.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderAddressCellTableViewCell.h"


@interface QGHOrderAddressCellTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end


@implementation QGHOrderAddressCellTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setReceiptAddressModel:(QGHReceiptAddressModel *)receiptAddressModel {
    _receiptAddressModel = receiptAddressModel;
    self.nameLabel.text = receiptAddressModel.username;
    self.phoneLabel.text = receiptAddressModel.phone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", receiptAddressModel.province, receiptAddressModel.city, receiptAddressModel.area, receiptAddressModel.address];
}


@end

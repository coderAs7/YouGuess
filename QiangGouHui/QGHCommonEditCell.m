//
//  QGHCommonEditCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHCommonEditCell.h"


@interface QGHCommonEditCell()

@property (weak, nonatomic, readwrite) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *textField;

@end


@implementation QGHCommonEditCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = F3;
    self.titleLabel.textColor = C8;
    
    self.textField.font = F3;
    self.textField.textColor = C8;
}


- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}


- (void)setPlaceHolder:(NSString *)placeHolder {
    _textField.placeholder = placeHolder;
}


@end

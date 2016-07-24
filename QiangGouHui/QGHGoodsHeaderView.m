//
//  QGHGoodsHeaderView.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/13.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHGoodsHeaderView.h"


@interface QGHGoodsHeaderView ()

@property (weak, nonatomic, readwrite) IBOutlet UIImageView *imageView;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *label1;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *verticalSeparator;

@end


@implementation QGHGoodsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    
    self.label1.textColor = [UIColor blackColor];
    self.label2.textColor = C7;
    self.verticalSeparator.backgroundColor = C6;
}

@end

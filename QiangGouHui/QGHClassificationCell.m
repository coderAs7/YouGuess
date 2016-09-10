//
//  QGHClassificationCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHClassificationCell.h"


@interface QGHClassificationCell ()

@property (nonatomic, strong) MMHImageView *img;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *arrow;

@end


@implementation QGHClassificationCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _img = [[MMHImageView alloc] initWithFrame:CGRectMake(15, 0, 30, 30)];
        _img.centerY = 20;
        [self.contentView addSubview:_img];
//        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.left.mas_equalTo(15);
//            make.width.and.height.mas_equalTo(30);
//        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = F3;
        _nameLabel.textColor = C6;
        [self.contentView addSubview:_nameLabel];
        
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sg_ic_down_up"]];
        [self.contentView addSubview:_arrow];
//        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.right.mas_equalTo(-15);
//        }];
    }
    
    return self;
}


- (void)setItem:(QGHClassificationItem *)item {
    _item = item;
    
    if (item.level > 0) {
        self.img.hidden = YES;
    } else {
        self.img.hidden = NO;
        [self.img updateViewWithImageAtURL:item.img_path];
    }
    
    self.nameLabel.text = item.name;
    [self.nameLabel sizeToFit];
    self.nameLabel.x = 55 + item.level * 15;
    self.nameLabel.centerY = 20;
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        if (item.level == 0) {
//            make.left.mas_equalTo(self.img.mas_right).offset(15);
//        } else {
//            make.left.mas_equalTo((item.level + 1) * 15);
//        }
//    }];
    
    
    if (item.canUnfold) {
        self.arrow.hidden = NO;
        if (item.isUnfold) {
            self.arrow.image = [UIImage imageNamed:@"sg_ic_down"];
        } else {
            self.arrow.image = [UIImage imageNamed:@"sg_ic_down_up"];
        }
        self.arrow.right = mmh_screen_width() * 2 / 3 - 15;
        self.arrow.centerY = 20;
    } else {
        self.arrow.hidden = YES;
    }
}


@end

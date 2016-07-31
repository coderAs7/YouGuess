//
//  QGHGroupCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/30.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHGroupCell.h"


@interface QGHGroupCell()
@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property (nonatomic, strong) MMHImageView *groupImageView;
@property (nonatomic, strong) QGHGroupModel *groupModel;

@end


@implementation QGHGroupCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageBackView.backgroundColor = [UIColor clearColor];
    
    _groupImageView = [[MMHImageView alloc] init];
    _groupImageView.layer.cornerRadius = 25;
    _groupImageView.layer.masksToBounds = YES;
    [self.imageBackView addSubview:_groupImageView];
    [self.groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageBackView);
        make.width.and.height.equalTo(self.imageBackView);
    }];
    
    self.joinButton.backgroundColor = C20;
    [self.joinButton setTitleColor:C21 forState:UIControlStateNormal];
    self.joinButton.layer.cornerRadius = 3.0;
    [self.joinButton addTarget:self action:@selector(joinButtonAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.joinButton.hidden = !self.showJoinButton;
}


- (void)setGroupModel:(QGHGroupModel *)model {
    _groupModel = model;
    
    [self.groupImageView updateViewWithImageAtURL:model.avatar_url];
    self.groupNameLabel.text = model.nickname;
    if (model.isMyGroup) {
        self.contentLabel.hidden = YES;
    } else {
        self.contentLabel.hidden = YES;
    }
}


- (void)joinButtonAction {
    if ([self.delegate respondsToSelector:@selector(groupCellJoin:)]) {
        [self.delegate groupCellJoin:self.groupModel];
    }
}


@end

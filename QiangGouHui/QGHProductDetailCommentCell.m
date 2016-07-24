//
//  QGHProductDetailCommentCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/29.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductDetailCommentCell.h"


@interface QGHProductDetailCommentCell ()
@property (weak, nonatomic) IBOutlet UIView *starBackView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;


@end


@implementation QGHProductDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.starBackView.backgroundColor = [UIColor clearColor];
    
    self.nickNameLabel.textColor = C7;
    self.nickNameLabel.font = F2;
    
    self.commentLabel.textColor = C8;
    self.commentLabel.font = F5;
    
    [self setStartNum:3];
}


- (void)setComment:(QGHProductDetailComment *)comment {
    self.commentLabel.text = comment.content;
    self.nickNameLabel.text = comment.username;
    [self setStartNum:comment.star];
}


- (void)setStartNum:(NSInteger)num {
    [self.starBackView removeAllSubviews];
    
    CGFloat originX = 0;
    for (NSInteger i = 0; i < num; ++i) {
        UIImage *star = [UIImage imageNamed:@"star"];
        UIImageView *starView = [[UIImageView alloc] initWithImage:star];
        starView.frame = CGRectMake(i * (star.size.width + 6), (22 - star.size.height) * 0.5, star.size.width, star.size.height);
        [self.starBackView addSubview:starView];
        originX = CGRectGetMaxX(self.starBackView.frame) + 6;
    }
    
    for (NSInteger i = 0; i < 5 - num; ++i) {
        UIImage *nStar = [UIImage imageNamed:@"star-_n"];
        UIImageView *nStarView = [[UIImageView alloc] initWithImage:nStar];
        nStarView.frame = CGRectMake(originX + i * (nStar.size.width + 6), (22 - nStar.size.height) * 0.5, nStar.size.width, nStar.size.height);
        [self.starBackView addSubview:nStarView];
    }
}


@end

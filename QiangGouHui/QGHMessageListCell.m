//
//  QGHMessageListCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/11.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHMessageListCell.h"
#import "EMClient.h"
#import "IMessageModel.h"
#import "EaseMessageModel.h"

@interface QGHMessageListCell ()

@property (weak, nonatomic) IBOutlet UIView *imageBack;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) MMHImageView *msgImageView;

@end


@implementation QGHMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageBack.backgroundColor = [UIColor clearColor];
    
//    _nameLabel.textColor = C;
    _latestMsgLabel.textColor = C7;
    _timeLabel.textColor = C6;
    
    _msgImageView = [[MMHImageView alloc] init];
    _msgImageView.layer.cornerRadius = 25;
    _msgImageView.layer.masksToBounds = YES;
    [self.imageBack addSubview:_msgImageView];
    [_msgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageBack);
        make.width.and.height.equalTo(self.imageBack);
    }];
}


- (void)setConversation:(QGHConversation *)conversation {
    if (conversation.conversationImg) {
        [self.msgImageView updateViewWithImage:conversation.conversationImg];
    } else {
        [self.msgImageView updateViewWithImageAtURL:conversation.conversationImgUrl];
    }
    
    self.nameLabel.text = conversation.conversationName;
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:conversation.message];
    NSString *text = nil;
    if (model.bodyType == EMMessageBodyTypeImage) {
        text = @"[图片]";
    } else if (model.bodyType == EMMessageBodyTypeVoice) {
        text = @"[语音]";
    } else {
        text = model.text;
    }
    NSString *content = [NSString stringWithFormat:@"%@:%@", model.nickname, text];
    self.latestMsgLabel.text = content;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:conversation.message.localTime];
    NSString *dateStr = [date stringRepresentationWithDateFormat:@"MM-dd HH:mm"];
    self.timeLabel.text = dateStr;
}


@end

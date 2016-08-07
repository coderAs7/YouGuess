//
//  QGHChatViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/31.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "EaseMessageViewController.h"
#import "QGHProductInfo.h"
#import "QGHGroupUserModel.h"

typedef NS_ENUM(NSInteger, QGHChatType) {
    QGHChatTypeChat,
    QGHChatTypeGroup,
};


@protocol QGHChatViewControllerDelegate <NSObject>

- (void)chatViewControllerLeaveGroupSuccess;

@end


@interface QGHChatViewController : EaseMessageViewController

@property (nonatomic, weak) id<QGHChatViewControllerDelegate> chatDelegate;
@property (nonatomic, assign) QGHChatType customChatType;
@property (nonatomic, copy) NSString *transferOrderNo;

- (instancetype)initWithProductInfo:(QGHProductInfo *)info;
- (instancetype)initWithGroupId:(NSString *)groupId UserArr:(NSArray<QGHGroupUserModel *> *)userArr;

@end

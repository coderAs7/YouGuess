//
//  QGHGroupHandleViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/31.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"


@protocol QGHGroupHandleViewControllerDelegate <NSObject>

- (void)groupHandleViewControllerClearChatRecord;
- (void)groupHandleViewControllerClearExitGroup;

@end


@interface QGHGroupHandleViewController : BaseViewController

@property (nonatomic, weak) id<QGHGroupHandleViewControllerDelegate> delegate;

@end

//
//  QGHChangeNickNameViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/23.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^NickNameSelectBlock)(NSString *nickName);

@interface QGHChangeNickNameViewController : BaseViewController

@property (nonatomic, copy) NickNameSelectBlock callback;

- (instancetype)initWithNickName:(NSString *)nickName;

@end

//
//  QGHLoginViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/20.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"


@class MMHAccount;


@interface QGHLoginViewController : BaseViewController

@property (nonatomic, copy) void(^succeededHandler)(MMHAccount *account);

@end

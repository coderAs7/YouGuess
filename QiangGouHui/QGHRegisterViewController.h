//
//  QGHRegisterViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/20.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"
#import "MMHAccount.h"
#import "QGHRegisterModel.h"


typedef NS_ENUM(NSInteger, QGHRegisterViewType) {
    QGHRegisterViewTypeNormal = 0,
    QGHRegisterViewTypeChangePwd = 1,
    QGHRegisterViewTypeBindPhone = 2,
};


@interface QGHRegisterViewController : BaseViewController

@property (nonatomic, strong) MMHAccount *account;
@property (nonatomic, assign) QGHLoginType loginType;
@property (nonatomic, copy) void(^bindPhoneSuccessBlock)(QGHRegisterModel *registerModel);

- (instancetype)initWithType:(QGHRegisterViewType)type;

@end

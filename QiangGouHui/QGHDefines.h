//
//  QGHDefines.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/1.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#ifndef QGHDefines_h
#define QGHDefines_h

typedef NS_ENUM(NSInteger, QGHBussType) {
    QGHBussTypeNormal,
    QGHBussTypePurchase,
    QGHBussTypeAppoint,
    QGHBussTypeCustom,
};


typedef NS_ENUM(NSInteger, QGHLoginType) {
    QGHLoginTypeNomal,
    QGHLoginTypeQQ,
    QGHLoginTypeWeChat,
};

#define kDefault_Token @"kDefault_Token"

#define SHARESDK_APPID @"156a84fb094b8"

#define WECHAT_APPID @"wx73ce0c7fa5af1828"
#define WECHAT_APPSECRET @"4387c33d9a29182e713286c8f48fcf89"

#define QQ_APPID @"1105571354"
#define QQ_APPKEY @"53XRwtOwQsWDBosu"

#define EaseMob_key @"gzyinyi#fenxiang"
#define EaseMob_push_production @"EaseMob_push_production"
#define EaseMobPwd @"QiangGouHui123"

#endif /* QGHDefines_h */

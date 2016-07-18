//
//  QGHWeChatPrePayModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/12.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHWeChatPrePayModel : MMHFetchModel

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *mch_id;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, assign) UInt32 timestamp;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *partnerid;

@end

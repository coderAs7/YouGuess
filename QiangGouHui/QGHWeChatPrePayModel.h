//
//  QGHWeChatPrePayModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/12.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHWeChatPrePayModel : MMHFetchModel

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *mch_id;
@property (nonatomic, copy) NSString *paySign;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, assign) UInt32 timeStamp;
@property (nonatomic, copy) NSString *prepay_id;
@property (nonatomic, copy) NSString *packages;
@property (nonatomic, copy) NSString *partnerid;

@end

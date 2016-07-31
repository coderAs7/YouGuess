//
//  QGHRegisterModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/28.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHRegisterModel : MMHFetchModel

@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) double expireTime;

@end

//
//  QGHGroupUserModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/8/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHGroupUserModel : MMHFetchModel

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *userId;

@end

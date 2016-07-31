//
//  QGHGroupModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/30.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHGroupModel : MMHFetchModel

@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *avatar_url;

@property (nonatomic, assign) BOOL isMyGroup;

@end

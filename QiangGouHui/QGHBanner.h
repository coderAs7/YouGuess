//
//  QGHBanner.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/24.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHBanner : MMHFetchModel

@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *target_url;
@property (nonatomic, assign) QGHBussType type;
@property (nonatomic, copy) NSString *typeid;
@property (nonatomic, copy) NSString *typename;

@end

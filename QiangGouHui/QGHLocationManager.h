//
//  QGHLocationManager.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGHLocationManager : NSObject

+ (QGHLocationManager *)shareManager;
+ (void)startLocation;

- (NSString *)currentCity;

@end

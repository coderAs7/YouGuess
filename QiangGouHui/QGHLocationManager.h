//
//  QGHLocationManager.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/5/29.
//  Copyright © 2016年 姚驰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGHLocationManager : NSObject

+ (QGHLocationManager *)sharedLocationManager;

+ (void)getArea;

@end

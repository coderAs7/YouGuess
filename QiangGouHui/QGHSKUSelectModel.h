//
//  QGHSKUSelectModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/7.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QGHSKUCategory.h"

@interface QGHSKUSelectModel : NSObject

@property (nonatomic, strong) NSDictionary<NSString*, QGHSKUCategory *> *selectedSKU;
@property (nonatomic, assign) NSInteger count;

@end

//
//  QGHProductSubClassViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/15.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"

@interface QGHProductSubClassViewController : BaseViewController

@property (nonatomic, assign) QGHBussType type;

- (instancetype)initWithSelectedGoodsType:(NSString *)selectedGoodsType selectedArea:(NSString *)area;

@end

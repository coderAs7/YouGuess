//
//  MMHPayWayViewController.h
//  MamHao
//
//  Created by YaoChi on 15/8/11.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "BaseViewController.h"
#import "MMHPayManager.h"

typedef void(^SelectPayWay)(MMHPayWay payWay);

@interface MMHPayWayViewController : BaseViewController

- (instancetype)initWithPayPrice:(float)price orderNo:(NSString *)orderNo payWay:(SelectPayWay)payWay;


@end

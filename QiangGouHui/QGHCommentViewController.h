//
//  QGHCommentViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/8/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"
#import "QGHOrderProduct.h"

@interface QGHCommentViewController : BaseViewController

- (instancetype)initWithProduct:(QGHOrderProduct *)goods orderId:(NSString *)orderId;

@end

//
//  QGHOrderDetailViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/25.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"

@protocol QGHOrderDetailViewControllerDelegate <NSObject>

- (void)orderDetailViewControllerHandleOrder;

@end

@interface QGHOrderDetailViewController : BaseViewController

@property (nonatomic, weak) id<QGHOrderDetailViewControllerDelegate> delegate;

- (instancetype)initWithOrderId:(NSString *)orderId;

@end

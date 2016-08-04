//
//  QGHOrderListViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/25.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"
#import "QGHOrderListItem.h"

@interface QGHOrderListViewController : BaseViewController

@property (nonatomic, assign) QGHOrderListItemStatus selectedStatus;

- (void)fetchData;

@end

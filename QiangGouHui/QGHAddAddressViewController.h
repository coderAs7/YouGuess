//
//  QGHAddAddressViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"
#import "QGHReceiptAddressModel.h"

@interface QGHAddAddressViewController : BaseViewController

@property (nonatomic, strong) QGHReceiptAddressModel *transferAddressModel;
@property (nonatomic, copy) void(^addressEditBlock)();
@property (nonatomic, copy) void(^addAddressBlock)();

@end

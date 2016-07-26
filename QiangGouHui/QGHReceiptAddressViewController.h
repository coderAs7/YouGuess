//
//  QGHReceiptAddressViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/24.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"
#import "QGHReceiptAddressModel.h"

typedef NS_ENUM(NSInteger, ReceiptAddressViewControllerType) {
    ReceiptAddressViewControllerTypeNormal,
    ReceiptAddressViewControllerTypeSelect,
};

@interface QGHReceiptAddressViewController : BaseViewController

@property (nonatomic, copy) void(^selectAddressBlock)(QGHReceiptAddressModel *address);
@property (nonatomic, assign) ReceiptAddressViewControllerType type;
@end

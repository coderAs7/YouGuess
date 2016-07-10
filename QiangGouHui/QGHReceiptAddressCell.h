//
//  QGHReceiptAddressCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/23.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGHReceiptAddressModel.h"


@class QGHReceiptAddressCell;


@protocol QGHReceiptAddressCellDelegate <NSObject>

- (void)receiptAddressCellSetDefaultAddress:(QGHReceiptAddressCell *)cell;
- (void)receiptAddressCellDeleteAddress:(QGHReceiptAddressCell *)cell;

@end


@interface QGHReceiptAddressCell : UITableViewCell

@property (nonatomic, weak) id<QGHReceiptAddressCellDelegate> delegate;
@property (nonatomic, strong) QGHReceiptAddressModel *receiptAddressModel;

@end

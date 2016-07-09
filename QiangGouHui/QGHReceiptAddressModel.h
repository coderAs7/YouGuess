//
//  QGHReceiptAddressModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/9.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHReceiptAddressModel : MMHFetchModel

@property (nonatomic, copy) NSString *receiptAddressId;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *isdefault; //1：默认，2：非默认

@end

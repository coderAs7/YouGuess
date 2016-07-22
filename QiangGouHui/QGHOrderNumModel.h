//
//  QGHOrderNumModel.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/22.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHOrderNumModel : MMHFetchModel

@property (nonatomic, assign) NSInteger waitpay;
@property (nonatomic, assign) NSInteger delivery;
@property (nonatomic, assign) NSInteger receipt;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger refund;

@end

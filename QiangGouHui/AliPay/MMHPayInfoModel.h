//
//  MMHPayInfoModel.h
//  MamHao
//
//  Created by SmartMin on 15/6/26.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHFetchModel.h"

@interface MMHPayInfoModel : MMHFetchModel

/*
 desc = "\U6b22\U8fce\U518d\U6b21\U8d2d\U4e70\U5988\U5988\U597d\U5546\U54c1.";
 goodCount = 1;
 goodName = "\U6c7d\U8f66\U5ea7";
 msg = "\U6267\U884c\U6210\U529f";
 price = "0.01";

 */

@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *goodCount;
@property (nonatomic,copy)NSString *goodName;
@property (nonatomic,copy)NSString *msg;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *orderBatchNo;

@end

//
//  QGHClassificationItem.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHClassificationItem : MMHFetchModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *img_path;
@property (nonatomic, strong) NSArray<QGHClassificationItem *> *itemArr;
@property (nonatomic, assign) BOOL canUnfold;
@property (nonatomic, assign) BOOL isUnfold;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) QGHBussType type;

@end

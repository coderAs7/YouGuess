//
//  QGHProductDetailComment.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFetchModel.h"

@interface QGHProductDetailComment : MMHFetchModel

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, copy) NSString *content;

@end

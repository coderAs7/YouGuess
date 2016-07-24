//
//  QGHCommentList.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/24.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHTimeline.h"
#import "QGHProductDetailScoreInfo.h"


@interface QGHCommentList : MMHTimeline

@property (nonatomic, strong, readonly) QGHProductDetailScoreInfo *scoreInfo;

- (instancetype)initWithGoodsId:(NSString *)goodsId;

@end

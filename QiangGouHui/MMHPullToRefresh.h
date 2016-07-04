//
//  MMHPullToRefresh.h
//  MamHao
//
//  Created by Louis Zhu on 15/6/13.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"


extern NSString *const MMHPullToRefreshHeaderViewStateIdleText;
extern NSString *const MMHPullToRefreshHeaderViewStatePullingText;
extern NSString *const MMHPullToRefreshHeaderViewStateRefreshingText;


@interface MMHPullToRefreshHeaderView: MJRefreshHeader

@end


@interface UIScrollView (MMHPullDownToRefresh)

//- (void)addLegendHeaderWithRefreshingBlock:(void (^)())block;
- (void)addLegendHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
- (void)addLegendFooterWithRefreshingBlock:(void (^)())block;
- (void)addLegendFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

- (void)addPullDownToRefreshHeaderWithRefreshingBlock:(void (^)())block;
- (void)addPullDownToRefreshHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@property (nonatomic, readonly) MJRefreshAutoNormalFooter *legendFooter;
- (void)removeHeader;
- (void)removeFooter;
@end



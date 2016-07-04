//
//  MMHTimeline.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/10.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MMHTimeline;


NS_ASSUME_NONNULL_BEGIN


@protocol MMHTimelineDelegate <NSObject>

- (void)timelineDataRefetched:(MMHTimeline *)timeline;
- (void)timelineMoreDataFetched:(MMHTimeline *)timeline;
- (void)timeline:(MMHTimeline *)timeline fetchingFailed:(NSError *)error;

@optional
- (void)timeline:(MMHTimeline *)timeline itemsDeletedAtIndexes:(NSIndexSet *)indexes;
- (void)timelineAllItemsDeleted:(MMHTimeline *)timeline;

@end



@interface MMHTimeline<__covariant ObjectType> : NSObject

@property (nonatomic, weak) id<MMHTimelineDelegate> delegate;

- (NSInteger)numberOfItems;
- (ObjectType __nullable)itemAtIndex:(NSInteger)index;
- (BOOL)hasMoreItems;

- (void)removeItem:(ObjectType)itemToRemove;
- (void)removeAllItems;

- (void)refetch;
- (void)fetchMore;

// MUST to override!
@property (nonatomic, readonly) NSInteger pageSize;
- (void)fetchItemsAtPage:(NSInteger)page succeededHandler:(void (^)(NSArray *fetchedItems))succeededHandler failedHandler:(void (^)(NSError *error))failedHandler;

@end


NS_ASSUME_NONNULL_END

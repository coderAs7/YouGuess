//
//  MMHTimeline.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/10.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHTimeline.h"


@interface MMHTimeline ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) NSInteger nextPage;
@property (nonatomic) BOOL allItemsFetched;
@end


@implementation MMHTimeline


- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}


- (NSInteger)pageSize
{
    return 20;
}


- (NSInteger)numberOfItems
{
    return self.items.count;
}


- (id)itemAtIndex:(NSInteger)index
{
    return [self.items nullableObjectAtIndex:index];
}


- (BOOL)hasMoreItems
{
    return !self.allItemsFetched;
}


- (void)removeItem:(id)itemToRemove {
    NSInteger index = [self.items indexOfObject:itemToRemove];
    if (index == NSNotFound) {
        return;
    }

    [self.items removeObjectAtIndex:index];
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:index];
    id<MMHTimelineDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(timeline:itemsDeletedAtIndexes:)]) {
        [delegate timeline:self itemsDeletedAtIndexes:indexes];
    }
}


- (void)removeAllItems {
    [self.items removeAllObjects];
    self.allItemsFetched = NO;
    self.nextPage = 0;
    
    id<MMHTimelineDelegate> delegte = self.delegate;
    if ([delegte respondsToSelector:@selector(timelineAllItemsDeleted:)]) {
        [delegte timelineAllItemsDeleted:self];
    }
}


- (void)refetch
{
    __weak __typeof(self) weakSelf = self;
    __weak id <MMHTimelineDelegate> delegate = self.delegate;

    [self.items removeAllObjects];
    self.allItemsFetched = NO;
    self.nextPage = 0;
    [self fetchItemsAtPage:self.nextPage succeededHandler:^(NSArray *fetchedItems) {
        if (fetchedItems.count < self.pageSize) {
            weakSelf.allItemsFetched = YES;
        }
        weakSelf.items = [fetchedItems mutableCopy];
        weakSelf.nextPage++;
        if ([delegate respondsToSelector:@selector(timelineDataRefetched:)]) {
            [delegate timelineDataRefetched:weakSelf];
        }
    } failedHandler:^(NSError *error) {
        if ([delegate respondsToSelector:@selector(timeline:fetchingFailed:)]) {
            [delegate timeline:weakSelf fetchingFailed:error];
        }
    }];
}


- (void)fetchMore {
    __weak __typeof(self) weakSelf = self;
    __weak id <MMHTimelineDelegate> delegate = self.delegate;
    
    NSInteger page = self.nextPage;
    if (![self hasMoreItems]) {
        page--;
        page = MAX(page, 0);
    }

    [self fetchItemsAtPage:page succeededHandler:^(NSArray *fetchedItems) {
        if (fetchedItems.count < self.pageSize) {
            weakSelf.allItemsFetched = YES;
        }
        if (page != 0) {
            [weakSelf.items appendUniqueObjectsFromArray:fetchedItems];
        } else {
            weakSelf.items = [fetchedItems mutableCopy];
        }
        
        weakSelf.nextPage = page + 1;
        if ([delegate respondsToSelector:@selector(timelineMoreDataFetched:)]) {
            [delegate timelineMoreDataFetched:weakSelf];
        }
    } failedHandler:^(NSError *error) {
        if ([delegate respondsToSelector:@selector(timeline:fetchingFailed:)]) {
            [delegate timeline:weakSelf fetchingFailed:error];
        }
    }];
}


- (void)fetchItemsAtPage:(NSInteger)page succeededHandler:(void (^)(NSArray *fetchedItems))succeededHandler failedHandler:(void (^)(NSError *error))failedHandler
{
    NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Unable to fetch data"}];
    failedHandler(error);
}


@end

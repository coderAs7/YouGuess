//
//  MMHSort.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/10.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MMHSort;


@protocol MMHSortDelegate <NSObject>

- (void)sortDidChange:(MMHSort *)sort;

@end


typedef NS_ENUM(NSInteger, MMHSortType) {
    MMHSortTypeDefault = 0,
    MMHSortTypeSales = 1,
    MMHSortTypePrice = 2,
    MMHSortTypeNew = 3,
};


typedef NS_ENUM(NSInteger, MMHSortOrder) {
    MMHSortOrderDescending = 0,
    MMHSortOrderAscending = 1,

    MMHSortOrderIgnored = -1,
};


extern BOOL MMHSortTypeHasOrderOptions(MMHSortType sortType);
extern MMHSortOrder MMHSortDefaultOrderForType(MMHSortType sortType);


@interface MMHSort : NSObject

@property (nonatomic, weak) id<MMHSortDelegate> delegate;

@property (nonatomic, readonly) MMHSortType type;
@property (nonatomic, readonly) MMHSortOrder order;

- (void)resortByDefault;
- (void)resortBySales;
- (void)resortByPrice;
- (void)resortByNew;

- (NSDictionary *)parameters;

- (void)resortByType:(MMHSortType)sortType;
@end

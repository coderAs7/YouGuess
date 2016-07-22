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
    MMHSortTypeDefault = 1,
    MMHSortTypeSales = 2,
    MMHSortTypePrice = 3,
    MMHSortTypeNew = 4,
};


typedef NS_ENUM(NSInteger, MMHSortOrder) {
    MMHSortOrderDescending = 1,
    MMHSortOrderAscending = 2,

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

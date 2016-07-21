//
//  MMHSort.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/10.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHSort.h"


BOOL MMHSortTypeHasOrderOptions(MMHSortType sortType)
{
    switch (sortType) {
        case MMHSortTypeDefault:
            return NO;
        case MMHSortTypeSales:
            return YES;
        case MMHSortTypePrice:
            return YES;
        case MMHSortTypeNew:
            return NO;
        default:
            break;
    }
    return NO;
}


MMHSortOrder MMHSortDefaultOrderForType(MMHSortType sortType)
{
    switch (sortType) {
        case MMHSortTypeDefault:
            return MMHSortOrderIgnored;
        case MMHSortTypeSales:
            return MMHSortOrderDescending;
        case MMHSortTypePrice:
            return MMHSortOrderAscending;
        case MMHSortTypeNew:
            return MMHSortOrderIgnored;
        default:
            break;
    }
}


@interface MMHSort ()

@property (nonatomic) MMHSortType type;
@property (nonatomic) MMHSortOrder order;
@end


@implementation MMHSort


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = MMHSortTypeDefault;
        self.order = MMHSortOrderIgnored;
    }
    return self;
}


- (void)resortByDefault
{
    if (self.type == MMHSortTypeDefault) {
        self.order = MMHSortOrderIgnored;
    }
    else {
        self.type = MMHSortTypeDefault;
        self.order = MMHSortOrderIgnored;
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(sortDidChange:)]) {
                [self.delegate sortDidChange:self];
            }
        }
    }
}


- (void)resortBySales
{
    if (self.type == MMHSortTypeSales) {
        [self reverseOrderWithDefaultValue:MMHSortOrderDescending];
    }
    else {
        self.type = MMHSortTypeSales;
        self.order = MMHSortOrderDescending;
    }

    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(sortDidChange:)]) {
            [self.delegate sortDidChange:self];
        }
    }
}


- (void)resortByPrice
{
    if (self.type == MMHSortTypePrice) {
        [self reverseOrderWithDefaultValue:MMHSortOrderAscending];
    }
    else {
        self.type = MMHSortTypePrice;
        self.order = MMHSortOrderAscending;
    }

    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(sortDidChange:)]) {
            [self.delegate sortDidChange:self];
        }
    }
}


- (void)resortByNew
{
    if (self.type == MMHSortTypeNew) {
        self.order = MMHSortOrderIgnored;
    }
    else {
        self.type = MMHSortTypeNew;
        self.order = MMHSortOrderIgnored;
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(sortDidChange:)]) {
                [self.delegate sortDidChange:self];
            }
        }
    }
}


- (void)reverseOrderWithDefaultValue:(MMHSortOrder)order
{
    switch (self.order) {
        case MMHSortOrderDescending:
            self.order = MMHSortOrderAscending;
            break;
        case MMHSortOrderAscending:
            self.order = MMHSortOrderDescending;
            break;
        default:
            self.order = order;
            break;
    }
}


- (NSDictionary *)parameters
{
    if (self.type == MMHSortTypeDefault || self.type == MMHSortTypeNew) {
        return @{@"searchType" : @(self.type), @"sort": @(0)};
    }
    else {
        return @{@"searchType" : @(self.type), @"sort" : @(self.order)};
    }
}


- (void)resortByType:(MMHSortType)sortType
{
    switch (sortType) {
        case MMHSortTypeDefault:
            [self resortByDefault];
            break;
        case MMHSortTypeSales:
            [self resortBySales];
            break;
        case MMHSortTypePrice:
            [self resortByPrice];
            break;
        case MMHSortTypeNew:
            [self resortByNew];
            break;
        default:
            break;
    }
}
@end

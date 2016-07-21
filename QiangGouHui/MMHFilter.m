//
//  MMHFilter.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/21.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHFilter.h"
#import "MMHSort.h"

@interface MMHFilter ()<MMHSortDelegate>

@property (nonatomic, strong, readwrite) MMHSort *sort;

@end


@implementation MMHFilter

- (id)initWithKeyword:(NSString *)keyword
{
    self = [self init];
    if (self) {
        self.keyword = keyword;
        self.module = MMHFilterModuleSearching;
        self.sort = [[MMHSort alloc] init];
        self.sort.delegate = self;
    }
    return self;
}

- (void)sortDidChange:(MMHSort *)sort
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(filterDidChange:)]) {
            [self.delegate filterDidChange:self];
        }
    }
}

@end

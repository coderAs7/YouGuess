//
//  MMHSearchViewController.h
//  MamHao
//
//  Created by 余传兴 on 15/5/14.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "BaseViewController.h"

@class MMHFilter;

typedef NS_ENUM(NSInteger, MMHSearchType) {
    MMHSearchTypeCommon = 0,
    MMHSearchTypeProductList
};

typedef void(^SearchCompletionBlock)(MMHFilter *filter);

@interface MMHSearchViewController : BaseViewController

@property (nonatomic) MMHSearchType type;
@property (nonatomic, copy) SearchCompletionBlock searchComplete;

- (instancetype)initWithKeyword:(NSString *)keyword;

@end

//
//  MMHFilter.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/21.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MMHFilterModule) {
    MMHFilterModuleCategory = 1,
    MMHFilterModuleSearching,
    MMHFilterModuleShop,
    MMHFilterModuleBrand,
    MMHFilterModulePromotionListFromProductDetail,
    MMHFilterModulePromotionFromCart,
};

@class MMHSort;
@class MMHFilter;


@protocol MMHFilterDelegate <NSObject>

- (void)filterDidChange:(MMHFilter *)filter;

@end


@interface MMHFilter : NSObject

@property (nonatomic, weak) id<MMHFilterDelegate> delegate;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic) MMHFilterModule module;
@property (nonatomic, readonly, strong) MMHSort *sort;

- (instancetype)initWithKeyword:(NSString *)keyword;

@end

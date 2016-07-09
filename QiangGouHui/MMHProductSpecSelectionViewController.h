//
//  MMHProductSpecSelectionViewController.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/16.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "BaseViewController.h"
#import "MMHFloatingViewController.h"

@class QGHProductDetailModel;

//@class MMHProductDetailModel;
//@protocol MMHProductDetailProtocol;
@class QGHSKUSelectModel;


@interface MMHProductSpecSelectionViewController : MMHFloatingViewController

@property (nonatomic) BOOL shouldShowAddingToCartAnimation;

//- (instancetype)initWithProductDetail:(id<MMHProductDetailProtocol>)productDetail isHideCount:(BOOL)isHideCount specSelectedHander:(void (^)(NSArray *selectedSpec))specSelectedHandler;

- (instancetype)initWithProductDetail:(QGHProductDetailModel *)productDetail specSelectedHandler:(void (^)(QGHSKUSelectModel *selectedModel))specSelectedHandler;

@end

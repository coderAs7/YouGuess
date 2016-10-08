//
//  QGHFirstSlideViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/10.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"


@protocol QGHFirstSlideViewControllerDelegate <NSObject>

- (void)slideViewControllerSelectType:(NSString *)goodstype title:(NSString *)title;

@end


@interface QGHFirstSlideViewController : BaseViewController

@property (nonatomic, weak) id<QGHFirstSlideViewControllerDelegate> delegate;

- (void)reloadData;

@end


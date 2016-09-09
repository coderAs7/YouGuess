//
//  QGHProductPicViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/8.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"


@protocol QGHProductPicViewControllerDelegate <NSObject>

- (void)scrollToTopBack;

@end


@interface QGHProductPicViewController : BaseViewController

@property (nonatomic, weak) id<QGHProductPicViewControllerDelegate> delegate;

- (void)setProductDetailUrl:(NSString *)url;

@end

//
//  QGHProductPicViewController.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/8.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "BaseViewController.h"


@protocol QGHProductPicViewController <NSObject>

- (void)scrollToTopBack;

@end


@interface QGHProductPicViewController : BaseViewController

- (void)setProductDetailUrl:(NSString *)url;

@end

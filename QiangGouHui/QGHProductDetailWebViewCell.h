//
//  QGHProductDetailWebViewCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QGHProductDetailWebViewCellDelegate <NSObject>

- (void)productDetailWebViewCellLoadedFinish:(CGFloat)webViewContentHeight;

@end


@interface QGHProductDetailWebViewCell : UITableViewCell

@property (nonatomic, weak) id<QGHProductDetailWebViewCellDelegate> delegate;

- (void)setProductDetailUrl:(NSString *)url;

@end

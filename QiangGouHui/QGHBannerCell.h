//
//  QGHBannerCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QGHBanner;


@protocol QGHBannerCellDelegate <NSObject>

- (void)bannerCellDidClick:(QGHBanner *)banner;

@end


@interface QGHBannerCell : UITableViewCell

@property (nonatomic, weak) id<QGHBannerCellDelegate> delegate;
@property (nonatomic, strong) NSArray<QGHBanner *> *bannerArr;

@end

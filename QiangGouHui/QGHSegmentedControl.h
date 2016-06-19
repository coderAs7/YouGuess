//
//  QGHSegmentedControl.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/20.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QGHSegmentedControlDelegate <NSObject>

- (void)segmentedControlDidSelected:(NSInteger)index;

@end


@interface QGHSegmentedControl : UIView

@property (nonatomic, weak) id<QGHSegmentedControlDelegate> delegate;

- (instancetype)initWithTitleArr:(NSArray *)arr;

@end

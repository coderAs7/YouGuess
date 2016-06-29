//
//  MMHDeleteLineLabel.h
//  MamHao
//
//  Created by SmartMin on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MMHDeleteLineLabel : UILabel

@property (nonatomic, assign) BOOL strikeThroughEnabled;       // 判断是否需要画线
@property (nonatomic, strong) UIColor *strikeThroughColor;     // 画线的颜色
@property (nonatomic, assign) BOOL isUnderLine;                /**< Yes下划线,No删除线*/
@end

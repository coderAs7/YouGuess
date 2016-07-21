//
//  MMHClassificationFooterView.h
//  MamHao
//
//  Created by fishycx on 15/5/21.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonAction)(UIButton *sender);

@interface MMHClassificationFooterView : UICollectionReusableView

@property (nonatomic, copy)ButtonAction buttonAction;


@end

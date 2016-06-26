//
//  MMHProductDetailHeaderCell.h
//  MamHao
//
//  Created by SmartMin on 15/6/15.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//
// 【妈妈好头部图片内容】
#import <UIKit/UIKit.h>

//@protocol MMHProductDetailHeaderCellDelegate <NSObject>
//
//- (void)imageScrollToLast;
//
//@end

@interface MMHProductDetailHeaderCell : UITableViewCell

//@property (nonatomic, weak) id<MMHProductDetailHeaderCellDelegate> delegate;
@property (nonatomic,strong) NSArray *imageArray;            // 传递过来的图片数组
@end

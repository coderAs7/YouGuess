//
//  QGHCommonCellTableViewCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/18.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QGHCommonCellTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) BOOL isHiddenArrow;

@end

//
//  QGHGroupCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/30.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGHGroupModel.h"


@protocol QGHGroupCellDelegate <NSObject>

- (void)groupCellJoin:(QGHGroupModel *)model;

@end


@interface QGHGroupCell : UITableViewCell

@property (nonatomic, weak) id<QGHGroupCellDelegate> delegate;
@property (nonatomic, assign) BOOL showJoinButton;

- (void)setGroupModel:(QGHGroupModel *)model;

@end

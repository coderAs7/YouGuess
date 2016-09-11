//
//  QGHMessageListCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/11.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGHConversation.h"

@interface QGHMessageListCell : UITableViewCell

@property (nonatomic, strong) QGHConversation *conversation;

@end

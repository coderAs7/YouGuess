//
//  QGHOrderDetailCommonCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/26.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QGHOrderDetailCommonCell : UITableViewCell

+ (CGFloat)heightWithData:(NSArray *)dataArr;

- (void)setData:(NSArray *)dataArr; //@[@{@"key": @"配送方式", @"value": @"快递配送"}]

@end

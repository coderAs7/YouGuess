//
//  MMHTableViewCell.h
//  MamHao
//
//  Created by YaoChi on 15/11/25.
//  Copyright © 2015年 Mamahao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMHTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly, nonnull) UILabel *titleLabel;
@property (nonatomic, assign) BOOL showArrow;
@property (nonatomic, strong, readonly, nonnull) UILabel *detailLabel;

@end

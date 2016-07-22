//
//  MMHPersonalCenterAllOrderCell.h
//  MamHao
//
//  Created by YaoChi on 16/1/4.
//  Copyright © 2016年 Mamahao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QGHOrderNumModel;


@interface MMHPersonalCenterAllOrderCellButton : UIButton

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, assign) NSInteger badgeCount;

@end



@protocol MMHPersonalCenterAllOrderCellDelegate <NSObject>

- (void)didClickPersonalCenterAllOrderCellButton:(NSInteger)index;

@end

@interface MMHPersonalCenterAllOrderCell : UITableViewCell

@property (nonatomic, weak) id<MMHPersonalCenterAllOrderCellDelegate> delegate;

//- (void)updateWithPersonalCenterInfoModel:(MMHPersonalCenterInfoModel *)model;
- (void)updateOrderNumModel:(QGHOrderNumModel *)model;

@end

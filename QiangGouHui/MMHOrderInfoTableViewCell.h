//
//  MMHOrderInfoTableViewCell.h
//  MamHao
//
//  Created by SmartMin on 15/4/28.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

// 订单信息
#import <UIKit/UIKit.h>
//#import "MMHOrderDetailModel.h"



@interface MMHOrderInfoTableViewCell : UITableViewCell


@property (nonatomic,strong)UIView *orderInfoView;          /**< 订单信息*/

@property (nonatomic,copy)NSString *orderNumber;            /**< 订单编号*/
@property (nonatomic,copy)NSString *orderingTime;           /**< 下单时间*/
@property (nonatomic,copy)NSString *orderState;             /**< 订单状态*/
@property (nonatomic,copy)NSString *hint;                   /**<邮费怎么怎么地*/
@property (nonatomic, copy) NSString *cloudPickShopName;

@property (nonatomic,strong)UILabel *orderNumberLabel;      /**< 订单编号label*/
@property (nonatomic,strong)UILabel *orderingTimeLabel;     /**< 下单时间label*/
@property (nonatomic,strong)UILabel *orderStateLabel;       /**< 订单状态label*/
@property (nonatomic,strong)UILabel *hintLabel;             /**< 邮费怎么怎么地Label*/
@property (nonatomic, strong) UILabel *cloudPickShopNameLabel;   /**<云店订单店铺名称*/

//+ (CGFloat)cellHeightWithorderDetailModel:(MMHOrderDetailModel *)orderDetailModel;
@end

//
//  QGHRushPurchaseItemsCell.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/12.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGHFirstPageGoodsList.h"


@interface QGHRushPurchaseItemsCell : UITableViewCell

- (void)setGoodList:(QGHFirstPageGoodsList *)goodList purchaseItemViewDelegate:(id)delegate;

@end

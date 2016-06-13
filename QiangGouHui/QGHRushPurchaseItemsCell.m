//
//  QGHRushPurchaseItemsCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/12.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHRushPurchaseItemsCell.h"
#import "QGHRushPurchaseItemView.h"


@interface QGHRushPurchaseItemsCell ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation QGHRushPurchaseItemsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 270)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_scrollView];
    }
    
    return self;
}


- (void)testFunc {
    if (self.contentView.subviews.count > 0) {
        return;
    }
    
    for (int i = 0; i < 5; ++i) {
        QGHRushPurchaseItemView *view = [[QGHRushPurchaseItemView alloc] initWithFrame:CGRectMake(i * (185 + 5), 0, 185, 270)];
        [self.scrollView addSubview:view];
    }
}


@end

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
@property (nonatomic, strong) NSMutableArray *itemViewArr;

@end


@implementation QGHRushPurchaseItemsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 270)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_scrollView];
        
        _itemViewArr = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)setGoodList:(QGHFirstPageGoodsList *)goodList purchaseItemViewDelegate:(id)delegate {
    [self.itemViewArr removeAllObjects];
    
    for (int i = 0; i < [goodList numberOfItems]; ++i) {
        QGHRushPurchaseItemView *view = (QGHRushPurchaseItemView *)[[[NSBundle mainBundle] loadNibNamed:@"QHGRushPurchaseItemView" owner:self options:nil] lastObject];
        [view setGoodsModel:[goodList itemAtIndex:i]];
        view.delegate = delegate;
        view.x = i * (185 + 5);
        [self.scrollView addSubview:view];
        [self.itemViewArr addObject:view];
    }
    
    self.scrollView.contentSize = CGSizeMake((185 + 5) * ([goodList numberOfItems] - 1) + 185, 270);
}


@end

//
//  MMHSortView.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/11.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHSortView.h"
#import "MMHFilter.h"
#import "MMHSort.h"
#import "MMHSortViewItem.h"


@interface MMHSortView ()

@property (nonatomic, strong) NSMutableArray *items;
@end


@implementation MMHSortView


- (instancetype)initWithFrame:(CGRect)frame filter:(MMHFilter *)filter
{
    self = [super initWithFrame:frame];
    if (self) {
        self.filter = filter;
        self.backgroundColor = [UIColor whiteColor];
        [self configureViews];
        //        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"综合", @"销量", @"价格", @"最新"]];
//        segmentedControl.frame = self.bounds;
//        segmentedControl.momentary = YES;
//        [segmentedControl addTarget:self action:@selector(selectedIndexChanged:) forControlEvents:UIControlEventValueChanged];
//        [self addAlwaysFitSubview:segmentedControl];
//        self.segmentedControl = segmentedControl;
    }
    
    return self;
}


- (void)configureViews
{
    self.items = [NSMutableArray array];
    
    NSArray *itemTypes = @[@(MMHSortTypeDefault), @(MMHSortTypeSales), @(MMHSortTypePrice), @(MMHSortTypeNew)];
    
    for (NSInteger i = 0; i < [itemTypes count]; i++) {
        MMHSortType sortType = (MMHSortType)([itemTypes[i] integerValue]);
        CGRect frame = [self frameAtIndex:i total:[itemTypes count]];
        MMHSortViewItem *item = [[MMHSortViewItem alloc] initWithFrame:frame sortType:sortType filter:self.filter];
        item.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
        [item addGestureRecognizer:tapGestureRecognizer];
        [self.items addObject:item];
        [self addSubview:item];
    }
    
    for (NSInteger j = 0; j < [itemTypes count] - 1; j++) {
        UIView *anItem = self.items[j];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(anItem.right - 0.5f, mmh_relative_float(10.0f), 1.0f, mmh_relative_float(22.0f))];
        line.backgroundColor = [QGHAppearance separatorColor];
        [self addSubview:line];
    }
    
    CGFloat bottomLineHeight = mmh_pixel();
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.bounds) - bottomLineHeight, self.bounds.size.width, bottomLineHeight)];
    bottomLine.backgroundColor = [QGHAppearance separatorColor];
    [self addSubview:bottomLine];
    
//    self.layer.masksToBounds = NO;
//    self.layer.shadowOffset = CGSizeMake(0, 5);
//    self.layer.shadowOpacity = 0.5;
}


- (void)itemTapped:(UITapGestureRecognizer *)gr
{
    MMHSortViewItem *item = (MMHSortViewItem *)gr.view;
    [self.filter.sort resortByType:item.sortType];
    for (MMHSortViewItem *item1 in self.items) {
        [item1 updateViews];
    }
}


- (CGRect)frameAtIndex:(NSInteger)i total:(NSInteger)total
{
    CGFloat w = self.width / (CGFloat)total;
    CGFloat h = self.height;
    CGRect result = CGRectMake((CGFloat)(i) * w, 0.0f, w, h);
    return result;
}


- (void)selectedIndexChanged:(id)sender
{
//    switch (self.segmentedControl.selectedSegmentIndex) {
//        case 0:
//            [self.filter.sort resortByDefault];
//            break;
//        case 1:
//            [self.filter.sort resortBySales];
//            break;
//        case 2:
//            [self.filter.sort resortByPrice];
//            break;
//        case 3:
//            [self.filter.sort resortByNew];
//            break;
//    }
}


@end

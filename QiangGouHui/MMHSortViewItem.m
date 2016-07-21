//
//  MMHSortViewItem.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/15.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHSortViewItem.h"
#import "MMHFilter.h"
#import "MMHSort.h"


@interface MMHSortViewItem ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end


@implementation MMHSortViewItem


- (instancetype)initWithFrame:(CGRect)frame sortType:(MMHSortType)sortType filter:(MMHFilter *)filter
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sortType = sortType;
        self.filter = filter;
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        self.contentView = contentView;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:mmh_relative_rect_make(0.0f, 0.0f, 24.0f, 12.0f)];
        titleLabel.centerY = CGRectGetMidY(self.contentView.bounds);
        titleLabel.textAlignment = NSTextAlignmentRight;
//        titleLabel.backgroundColor = [UIColor orangeColor];
        titleLabel.font = MMHFontOfSize(14.0f);
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;

        if (MMHSortTypeHasOrderOptions(sortType)) {
            titleLabel.textAlignment = NSTextAlignmentCenter;

//            MMHSortOrder defaultOrder = MMHSortDefaultOrderForType(sortType);
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setSize:CGSizeMake(8.0f, 8.0f)];
            imageView.frame = mmh_relative_rect(imageView.frame);
//            imageView.backgroundColor = [UIColor greenColor];
            [imageView attachToRightSideOfView:titleLabel byDistance:mmh_relative_float(6.0f)];
            imageView.centerY = CGRectGetMidY(self.contentView.bounds);
            [self.contentView addSubview:imageView];
            self.imageView = imageView;
        }

        [self configureViews];
    }
    return self;
}


- (void)configureViews
{
    switch (self.sortType) {
        case MMHSortTypeDefault: {
            [self.titleLabel setSingleLineText:@"综合" constrainedToWidth:CGFLOAT_MAX];
            break;
        }
        case MMHSortTypeSales: {
            [self.titleLabel setSingleLineText:@"销量" constrainedToWidth:CGFLOAT_MAX];
            break;
        }
        case MMHSortTypePrice: {
            [self.titleLabel setSingleLineText:@"价格" constrainedToWidth:CGFLOAT_MAX];
            break;
        }
        case MMHSortTypeNew: {
            [self.titleLabel setSingleLineText:@"最新" constrainedToWidth:CGFLOAT_MAX];
            break;
        }
        default:
            break;
    }
    self.titleLabel.centerY = CGRectGetMidY(self.contentView.bounds);

    [self.contentView setWidth:self.titleLabel.right];
    if (self.imageView) {
        [self.contentView setWidth:self.imageView.right];
    }
    self.contentView.centerX = CGRectGetMidX(self.bounds);
    [self updateViews];
}


- (void)updateViews
{
    MMHSortType activeSortType = self.filter.sort.type;
    if (activeSortType == self.sortType) {
        self.titleLabel.textColor = [UIColor mamhaoMainColor];

        if (MMHSortTypeHasOrderOptions(self.sortType)) {
            MMHSortOrder activeSortOrder = self.filter.sort.order;
            [self updateImageViewWithSortOrder:activeSortOrder];
            if (activeSortOrder == MMHSortOrderIgnored) {
                self.imageView.tintColor = C6;
            }
            else {
                self.imageView.tintColor = [UIColor mamhaoMainColor];
            }
        }
    }
    else {
        self.titleLabel.textColor = C6;

        if (MMHSortTypeHasOrderOptions(self.sortType)) {
            MMHSortOrder defaultOrder = MMHSortDefaultOrderForType(self.sortType);
            [self updateImageViewWithSortOrder:defaultOrder];
        }
        self.imageView.tintColor = C6;
    }
}


- (void)updateImageViewWithSortOrder:(MMHSortOrder)order
{
    if (self.imageView == nil) {
        return;
    }

    switch (order) {
        case MMHSortOrderDescending: {
            self.imageView.image = [[UIImage imageNamed:@"filter_sort_descending"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            break;
        }
        case MMHSortOrderAscending: {
            self.imageView.image = [[UIImage imageNamed:@"filter_sort_ascending"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            break;
        }
        default: {
            break;
        }
    }
}
@end

//
//  QGHBannerCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHBannerCell.h"


@interface QGHBannerCell()<UIScrollViewDelegate>

@property (nonatomic, strong) MMHImageView *defaultImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end


@implementation QGHBannerCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _defaultImage = [[MMHImageView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 200)];
        [self.contentView addSubview:_defaultImage];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 200)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, MMHFloat(150) - 10 - 7, kScreenWidth, 7)];
        _pageControl.currentPageIndicatorTintColor = C20;
        _pageControl.pageIndicatorTintColor = [C2 colorWithAlphaComponent:0.5];
        _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        [_scrollView addSubview:_pageControl];
    }
    
    return self;
}


#pragma mark - Action


- (void)pageTurn:(UIPageControl *)sender {
    NSInteger pageIndex = sender.currentPage;
    [self.scrollView setContentOffset:CGPointMake(pageIndex * kScreenWidth, 0) animated:YES];
}


#pragma mark - UIScrollView delegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageIndex = (NSInteger)(scrollView.contentOffset.x / kScreenWidth);
    self.pageControl.currentPage = pageIndex;
}


@end

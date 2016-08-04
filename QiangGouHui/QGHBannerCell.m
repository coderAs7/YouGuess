//
//  QGHBannerCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHBannerCell.h"
#import "QGHBanner.h"


@interface QGHBannerCell()<UIScrollViewDelegate>

@property (nonatomic, strong) MMHImageView *defaultImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

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
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 200 - 10 - 7, mmh_screen_width(), 7)];
        _pageControl.currentPageIndicatorTintColor = C20;
        _pageControl.pageIndicatorTintColor = [C2 colorWithAlphaComponent:0.5];
        _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_pageControl];
    }
    
    return self;
}


- (void)startTimer {
    //    [[Gatling sharedGatling] loadWithTarget:self timeInterval:4 shootsImmediately:NO bullet:nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timerTurnPage) userInfo:nil repeats:YES];
}

- (void)clearTimer {
    //    [[Gatling sharedGatling] stopShootingTarget:self];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Action


- (void)pageTurn:(UIPageControl *)sender {
    NSInteger pageIndex = sender.currentPage;
    [self.scrollView setContentOffset:CGPointMake(pageIndex * kScreenWidth, 0) animated:YES];
}


- (void)timerTurnPage {
    NSInteger nextPageIndex = (self.pageControl.currentPage + 1) % self.pageControl.numberOfPages;
    self.pageControl.currentPage = nextPageIndex;
    [self.scrollView setContentOffset:CGPointMake(nextPageIndex * kScreenWidth, 0) animated:YES];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self clearTimer];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self clearTimer];
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageIndex = (NSInteger)(scrollView.contentOffset.x / kScreenWidth);
    self.pageControl.currentPage = pageIndex;
}


- (void)setBannerArr:(NSArray<QGHBanner *> *)bannerArr {
    [self clearTimer];
    
    _bannerArr = bannerArr;
    [self.scrollView removeAllSubviews];
    
    for (int i = 0; i < self.bannerArr.count; ++i) {
        MMHImageView *imageView = [[MMHImageView alloc] initWithFrame:CGRectMake(i * mmh_screen_width(), 0, mmh_screen_width(), self.scrollView.height)];
        QGHBanner *banner = self.bannerArr[i];
        [imageView updateViewWithImageAtURL:banner.img_url];
        imageView.userInteractionEnabled = YES;
        imageView.actionBlock = ^{
            if ([self.delegate respondsToSelector:@selector(bannerCellDidClick:)]) {
                [self.delegate bannerCellDidClick:banner];
            }
        };
        [self.scrollView addSubview:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(mmh_screen_width() * bannerArr.count, self.scrollView.height);
    
    self.pageControl.numberOfPages = bannerArr.count;
    [self.pageControl sizeToFit];
    self.pageControl.height = 7;
    self.pageControl.bottom = self.scrollView.height - 10;
    self.pageControl.centerX = mmh_screen_width() * 0.5;
    
    [self startTimer];
}


@end

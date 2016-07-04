//
//  MMHPullToRefresh.m
//  MamHao
//
//  Created by Louis Zhu on 15/6/13.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHPullToRefresh.h"
#import <MJRefresh/MJRefreshHeader.h>
#import <MJRefresh/MJRefreshFooter.h>


NSString *const MMHPullToRefreshHeaderViewStateIdleText = @"下拉可以刷新";
NSString *const MMHPullToRefreshHeaderViewStatePullingText = @"松开立即刷新";
NSString *const MMHPullToRefreshHeaderViewStateRefreshingText = @"妈妈好正在加载哦~";


NSString *const MMHPullToRefreshHeaderViewImageViewRotationAnimation = @"MMHPullToRefreshHeaderViewImageViewRotationAnimation";


@interface MMHPullToRefreshHeaderView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end


@implementation MMHPullToRefreshHeaderView


- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.stateHidden = YES;
//        self.updatedTimeHidden = YES;

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_icon_refresh"]];
        imageView.left = mmh_screen_width() * 0.5f - 54.0f;
        imageView.centerY = CGRectGetMidY(self.bounds);
        [self addSubview:imageView];
        self.imageView = imageView;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.right + 6.0f, 0.0f, 0.0f, self.bounds.size.height)];
        [label setMaxX:mmh_screen_width()];
        label.textColor = C5;
        label.font = F0;
        label.text = MMHPullToRefreshHeaderViewStateIdleText;
        [self addSubview:label];
        self.label = label;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.centerY = CGRectGetMidY(self.bounds);
    self.label.top = 0.0f;
    self.label.height = CGRectGetMaxY(self.bounds);
}

#pragma mark - 公共方法
#pragma mark 设置状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState

    switch (state) {
        case MJRefreshStateIdle: {
            self.label.text = MMHPullToRefreshHeaderViewStateIdleText;
            if (oldState == MJRefreshStateRefreshing) {
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration
                                 animations:^{
                                     self.imageView.alpha = 0.0f;
                                 } completion:^(BOOL finished) {
                            [self.imageView.layer removeAllAnimations];
                        }];
                [self.imageView.layer removeAllAnimations];
//                self.arrowImage.transform = CGAffineTransformIdentity;
//
//                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
//                    self.activityView.alpha = 0.0;
//                } completion:^(BOOL finished) {
//                    self.arrowImage.alpha = 1.0;
//                    self.activityView.alpha = 1.0;
//                    [self.activityView stopAnimating];
//                }];
            } else {
//                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//                    self.arrowImage.transform = CGAffineTransformIdentity;
//                }];
            }
            break;
        }

        case MJRefreshStatePulling: {
            self.label.text = MMHPullToRefreshHeaderViewStatePullingText;
//            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//                self.arrowImage.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
//            }];
            break;
        }

        case MJRefreshStateRefreshing: {
            self.imageView.alpha = 1.0f;

            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            animation.byValue = @(M_PI * 2.0);
            animation.duration = 0.5;
            animation.repeatCount = 10000;
            [self.imageView.layer addAnimation:animation forKey:MMHPullToRefreshHeaderViewImageViewRotationAnimation];

            self.label.text = MMHPullToRefreshHeaderViewStateRefreshingText;
//            [self.activityView startAnimating];
//            self.arrowImage.alpha = 0.0;
            break;
        }

        default:
            break;
    }

    // super里面有回调，应该在最后面调用
    [super setState:state];
}


@end


@implementation UIScrollView (MMHPullToRefresh)


//- (void)addLegendHeaderWithRefreshingBlock:(void (^)())block {
//}


- (void)addLegendHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    header.refreshingTarget = target;
    header.refreshingAction = action;
    self.mj_header = header;
}


- (void)addLegendFooterWithRefreshingBlock:(void (^)())block {
    MJRefreshAutoNormalFooter *footer = [[MJRefreshAutoNormalFooter alloc] init];
    footer.refreshingBlock = block;
    self.mj_footer = footer;
}


- (void)addLegendFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    MJRefreshAutoNormalFooter *footer = [[MJRefreshAutoNormalFooter alloc] init];
    footer.refreshingTarget = target;
    footer.refreshingAction = action;
    self.mj_footer = footer;
}


- (MJRefreshAutoNormalFooter *)legendFooter {
    return (MJRefreshAutoNormalFooter *)self.mj_footer;
}


- (void)addPullDownToRefreshHeaderWithRefreshingBlock:(void (^)())block {
    MMHPullToRefreshHeaderView *header = [[MMHPullToRefreshHeaderView alloc] init];
    header.refreshingBlock = block;
    self.mj_header = header;
}


- (void)addPullDownToRefreshHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    MMHPullToRefreshHeaderView *header = [[MMHPullToRefreshHeaderView alloc] init];
    header.refreshingTarget = target;
    header.refreshingAction = action;
    self.mj_header = header;
}


- (void)removeHeader {
    self.mj_header = nil;
}


- (void)removeFooter {
    self.mj_footer = nil;
}


@end

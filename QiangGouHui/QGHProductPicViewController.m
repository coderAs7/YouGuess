//
//  QGHProductPicViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/8.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductPicViewController.h"
#import "MMHProductDetailPullDownHeaderView.h"


@interface QGHProductPicViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end


@implementation QGHProductPicViewController


- (void)dealloc {
    NSLog(@"fuck1");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), self.view.bounds.size.height - 64 - 48)];
    _webView.backgroundColor = [QGHAppearance backgroundColor];
    _webView.scalesPageToFit = YES;
    [_webView.scrollView addSubview:[self pullDownView]];
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
}

- (void)setProductDetailUrl:(NSString *)url {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}


- (MMHProductDetailPullDownHeaderView *)pullDownView {
    MMHProductDetailPullDownHeaderView *pullDownView = [[MMHProductDetailPullDownHeaderView alloc] initWithFrame:CGRectMake(0, -50, kScreenWidth, 50)];
    pullDownView.image = [UIImage imageNamed:@"product_ic_toup"];
    pullDownView.tip = @"下拉返回商品详情";
    
    return pullDownView;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -50) {
        if ([self.delegate respondsToSelector:@selector(scrollToTopBack)]) {
            [self.delegate scrollToTopBack];
        }
    }
}


@end

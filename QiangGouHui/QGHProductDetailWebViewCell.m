//
//  QGHProductDetailWebViewCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductDetailWebViewCell.h"


@interface QGHProductDetailWebViewCell ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL loaded;

@end


@implementation QGHProductDetailWebViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 300)];
//        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.delegate = self;
        [self.contentView addSubview:_webView];
    }
    
    return self;
}


- (void)setProductDetailUrl:(NSString *)url {
    if (url.length > 0 && !self.loaded) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
        self.loaded = YES;
    }
}


#pragma mark - UIWebView 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    self.loaded = YES;
    return YES;
}

//- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    CGFloat webViewWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth"] floatValue];
    CGFloat realHeight = (webViewHeight / webViewWidth) * mmh_screen_width();
    self.webView.height = realHeight;
    
    if ([self.delegate respondsToSelector:@selector(productDetailWebViewCellLoadedFinish:)]) {
        [self.delegate productDetailWebViewCellLoadedFinish:realHeight];
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.webView.height = 0;
    if ([self.delegate respondsToSelector:@selector(productDetailWebViewCellLoadedFinish:)]) {
        [self.delegate productDetailWebViewCellLoadedFinish:0];
    }
}


@end

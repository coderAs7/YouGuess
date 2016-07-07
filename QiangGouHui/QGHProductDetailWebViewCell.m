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
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 0)];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _webView.delegate = self;
        [self.contentView addSubview:_webView];
    }
    
    return self;
}


- (void)setProductDetailUrl:(NSString *)url {
    if (url.length > 0 && !self.loaded) {
        [self.webView loadHTMLString:url baseURL:nil];
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
    self.webView.height = webViewHeight;
    if ([self.delegate respondsToSelector:@selector(productDetailWebViewCellLoadedFinish:)]) {
        [self.delegate productDetailWebViewCellLoadedFinish:webViewHeight];
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    self.webView.height = 0;
    if ([self.delegate respondsToSelector:@selector(productDetailWebViewCellLoadedFinish:)]) {
        [self.delegate productDetailWebViewCellLoadedFinish:0];
    }
}


@end

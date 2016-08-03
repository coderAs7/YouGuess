//
//  AppWebViewController.m
//  easydoctor
//
//  Created by stone on 15/11/12.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "AppWebViewController.h"

@interface AppWebViewController ()<UIWebViewDelegate>

@end

@implementation AppWebViewController
{
    UIWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _webTitle;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), mmh_screen_height() - 64)];
    _webView.delegate = self;
    _webView.contentMode = UIViewContentModeScaleAspectFit;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scalesPageToFit = YES;
    [_webView sizeToFit];
    
    if (_localHtmlString == nil) {
        if (_localHtml.length > 0) {
            NSString* path = [[NSBundle mainBundle] pathForResource:_localHtml ofType:@"html"];
            NSURL* url = [NSURL fileURLWithPath:path];
            NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
            [_webView loadRequest:request];
            
        }else{
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
            [_webView loadRequest:request];
        }
    } else {
        [_webView loadHTMLString:_localHtmlString baseURL:nil];
        //重新布局
        [self layoutSubViews];
    }
    
    [self.view addSubview:_webView];

}

//重新布局字视图
- (void)layoutSubViews {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHudInView:self.view hint:@""];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
    if (self.webTitle.length <= 0) {
        self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

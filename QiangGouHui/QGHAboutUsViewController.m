//
//  QGHAboutUsViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/23.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHAboutUsViewController.h"
#import "MMHNetworkAdapter+Personal.h"


@interface QGHAboutUsViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextView *textView;

@end


@implementation QGHAboutUsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [self.view addSubview:self.imageView];
    
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.editable = NO;
    self.textView.font = F5;
    self.textView.textColor = C8;
    [self.view addSubview:self.textView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(100);
        make.top.mas_equalTo(30);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.width.mas_equalTo(mmh_screen_width() - 30);
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    
    
    [[MMHNetworkAdapter sharedAdapter] fetchAboutUsFrom:self succeededHandler:^(NSString *aboutUsStr) {
        self.textView.text = aboutUsStr;
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


@end

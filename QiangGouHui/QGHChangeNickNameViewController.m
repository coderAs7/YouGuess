//
//  QGHChangeNickNameViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/23.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHChangeNickNameViewController.h"


@interface QGHChangeNickNameViewController ()

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) UIView *textFieldBackView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *button;

@end


@implementation QGHChangeNickNameViewController


- (instancetype)initWithNickName:(NSString *)nickName {
    self = [super init];
    
    if (self) {
        _nickName = nickName;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    
    _textFieldBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, mmh_screen_width(), 48)];
    _textFieldBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textFieldBackView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, mmh_screen_width() - 30, 48)];
    _textField.font = F4;
    _textField.textColor = C8;
    _textField.placeholder = @"请输入昵称";
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.text = self.nickName;
    [_textFieldBackView addSubview:_textField];
    
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.textColor = C7;
    _tipsLabel.font = F3;
    _tipsLabel.text = @"昵称最长为10个字";
    [_tipsLabel sizeToFit];
    _tipsLabel.x = 15;
    _tipsLabel.top = _textFieldBackView.bottom + 10;
    [self.view addSubview:_tipsLabel];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, mmh_screen_width() - 30, 48)];
    _button.backgroundColor = C20;
    _button.layer.cornerRadius = 5;
    [_button setTitle:@"保存" forState:UIControlStateNormal];
    [_button setTitleColor:C21 forState:UIControlStateNormal];
    _button.top = _tipsLabel.bottom + 20;
    [_button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}


- (void)saveAction {
    if (self.textField.text.length == 0) {
        [self.view showTips:@"昵称不能为空！"];
        return;
    }
    
    self.callback(self.textField.text);
}


@end

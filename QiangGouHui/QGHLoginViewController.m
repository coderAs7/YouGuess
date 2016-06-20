//
//  QGHLoginViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/20.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHLoginViewController.h"
#import "QGHRegisterViewController.h"


@interface QGHLoginViewController ()

@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextField *telTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIButton *loginButton;

@end


@implementation QGHLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [QGHAppearance backgroundColor];
    
    [self setNavigationBar];
    
    [self makeInputView];
    
    [self makeLoginButton];
    
    [self makeForgetPasswordButton];
    
    [self makeStrollButton];
}


- (void)setNavigationBar {
    self.title = @"登录";
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cart_ic"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"快速注册" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

}


- (void)makeInputView {
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, mmh_screen_width(), 96)];
    _inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_inputView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 48, mmh_screen_width() - 30, 1)];
    line.backgroundColor = [QGHAppearance backgroundColor];
    [_inputView addSubview:line];
    
    _telTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, mmh_screen_width() - 30, 48)];
    _telTextField.font = F4;
    _telTextField.textColor = C7;
    _telTextField.placeholder = @"请输入手机号";
    _telTextField.clearButtonMode = UITextFieldViewModeAlways;
    [_inputView addSubview:_telTextField];
    
    _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 48, mmh_screen_width() - 30, 48)];
    _pwdTextField.font = F4;
    _pwdTextField.textColor = C7;
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.placeholder = @"请输入密码";
    [_inputView addSubview:_pwdTextField];
}


- (void)makeLoginButton {
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, mmh_screen_width() - 30, 48)];
    [_loginButton attachToBottomSideOfView:_inputView byDistance:30];
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.masksToBounds = YES;
    _loginButton.titleLabel.font = F8;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:C26 forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [_loginButton setBackgroundImage:[UIImage patternImageWithColor:[QGHAppearance themeColor]] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage patternImageWithColor:C3] forState:UIControlStateDisabled];
    [self.view addSubview:_loginButton];
}


- (void)makeForgetPasswordButton {
    UIButton *forgetButon = [[UIButton alloc] init];
    [forgetButon setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetButon setTitleColor:C4 forState:UIControlStateNormal];
    forgetButon.titleLabel.font = F3;
    forgetButon.x = 15;
    [forgetButon attachToBottomSideOfView:self.loginButton byDistance:18];
    [forgetButon sizeToFit];
    [self.view addSubview:forgetButon];
}


- (void)makeStrollButton {
    UIButton *strollButton = [[UIButton alloc] init];
    [strollButton setTitle:@"随便逛逛 >>" forState:UIControlStateNormal];
    [strollButton setTitleColor:C4 forState:UIControlStateNormal];
    strollButton.titleLabel.font = F3;
    [strollButton sizeToFit];
    strollButton.right = self.loginButton.right;
    [strollButton attachToBottomSideOfView:self.loginButton byDistance:18];
    [self.view addSubview:strollButton];
}


#pragma mark - Actions


- (void)leftBarButtonItemAction {
    [self dismissViewControllerWithAnimation];
}


- (void)rightBarButtonItemAction {
    [self presentRegisterViewControllerWithSucceededHandler:^{
    }];
}


@end

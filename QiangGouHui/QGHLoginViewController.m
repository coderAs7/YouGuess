//
//  QGHLoginViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/20.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHLoginViewController.h"
#import "QGHRegisterViewController.h"
#import "MMHNetworkAdapter+Login.h"
#import <ShareSDK/ShareSDK.h>
#import "MMHAccount.h"
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
    
    [self makeThirdLoginViews];
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
    [_loginButton setTitleColor:C21 forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [_loginButton setBackgroundImage:[UIImage patternImageWithColor:[QGHAppearance themeColor]] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage patternImageWithColor:C3] forState:UIControlStateDisabled];
    [_loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
}


- (void)makeForgetPasswordButton {
    UIButton *forgetButon = [[UIButton alloc] init];
    [forgetButon setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetButon setTitleColor:C7 forState:UIControlStateNormal];
    forgetButon.titleLabel.font = F3;
    forgetButon.x = 15;
    [forgetButon attachToBottomSideOfView:self.loginButton byDistance:18];
    [forgetButon sizeToFit];
    [forgetButon addTarget:self action:@selector(forgetButonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButon];
}


- (void)makeStrollButton {
    UIButton *strollButton = [[UIButton alloc] init];
    [strollButton setTitle:@"随便逛逛 >>" forState:UIControlStateNormal];
    [strollButton setTitleColor:C7 forState:UIControlStateNormal];
    strollButton.titleLabel.font = F3;
    [strollButton sizeToFit];
    strollButton.right = self.loginButton.right;
    [strollButton attachToBottomSideOfView:self.loginButton byDistance:18];
    [self.view addSubview:strollButton];
}


- (void)makeThirdLoginViews {
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [QGHAppearance separatorColor];
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [QGHAppearance separatorColor];
    [self.view addSubview:line2];
    
    UILabel *thirdLoginTitle = [[UILabel alloc] init];
    thirdLoginTitle.font = F3;
    thirdLoginTitle.textColor = C6;
    thirdLoginTitle.text = @"使用第三方帐号登录";
    [self.view addSubview:thirdLoginTitle];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-130);
        make.height.mas_equalTo(0.5);
    }];
    
    [thirdLoginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line1.mas_right).offset(10);
        make.centerY.equalTo(line1.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdLoginTitle.mas_right).offset(10);
        make.centerY.equalTo(thirdLoginTitle.mas_centerY);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *qqButton = [[UIButton alloc] init];
    [qqButton setImage:[UIImage imageNamed:@"sns_icon_24"] forState:UIControlStateNormal];
    [qqButton sizeToFit];
    [qqButton addTarget:self action:@selector(qqButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqButton];
    
    UILabel *qqLabel = [[UILabel alloc] init];
    qqLabel.text = @"QQ";
    qqLabel.font = F3;
    qqLabel.textColor = C6;
    [qqLabel sizeToFit];
    [self.view addSubview:qqLabel];
    
    UIButton *weChatButton = [[UIButton alloc] init];
    [weChatButton setImage:[UIImage imageNamed:@"sns_icon_22"] forState:UIControlStateNormal];
    [weChatButton sizeToFit];
    [weChatButton addTarget:self action:@selector(weChatButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weChatButton];
    
    UILabel *weChatLabel = [[UILabel alloc] init];
    weChatLabel.text = @"微信";
    weChatLabel.font = F3;
    weChatLabel.textColor = C6;
    [weChatLabel sizeToFit];
    [self.view addSubview:weChatLabel];
    
    UIButton *weiboButton = [[UIButton alloc] init];
    [weiboButton setImage:[UIImage imageNamed:@"sns_icon_2"] forState:UIControlStateNormal];
    [weiboButton sizeToFit];
    [weiboButton addTarget:self action:@selector(weiboButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboButton];
    
    UILabel *weiboLabel = [[UILabel alloc] init];
    weiboLabel.text = @"微博";
    weiboLabel.font = F3;
    weiboLabel.textColor = C6;
    [weiboLabel sizeToFit];
    [self.view addSubview:weiboLabel];
    
    CGFloat originYOffset = (130 - qqButton.height - 10 - qqLabel.height) * 0.5;
    CGFloat horizonalGap = (mmh_screen_width() - qqButton.width - weChatButton.width - weiboButton.width) / 4.0;
    
    [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(originYOffset);
        make.left.mas_equalTo(horizonalGap);
    }];
    
    [qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qqButton.mas_centerX);
        make.top.equalTo(qqButton.mas_bottom).offset(10);
    }];
    
    [weChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qqButton.mas_right).offset(horizonalGap);
        make.top.equalTo(qqButton);
    }];
    
    [weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weChatButton.mas_bottom).offset(10);
        make.centerX.equalTo(weChatButton.mas_centerX);
    }];
    
    [weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weChatButton.mas_right).offset(horizonalGap);
        make.top.equalTo(weChatButton);
    }];
    
    [weiboLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weiboButton.mas_bottom).offset(10);
        make.centerX.equalTo(weiboButton.mas_centerX);
    }];
}


#pragma mark - Actions


- (void)loginButtonAction {
    [[MMHNetworkAdapter sharedAdapter] loginWithPhoneNumber:self.telTextField.text passCode:self.pwdTextField.text loginType:QGHLoginTypeNomal from:self succeededHandler:^(MMHAccount *account) {
        if (self.succeededHandler) {
            self.succeededHandler(account);
        }
        [self dismissViewControllerWithAnimation];
    } failedHandler:^(NSError *error) {
    }];
}

- (void)leftBarButtonItemAction {
    [self dismissViewControllerWithAnimation];
}


- (void)rightBarButtonItemAction {
    [self presentRegisterViewControllerWithSucceededHandler:^{
        [self.navigationController popToViewController:self animated:YES];
    }];
}


- (void)forgetButonAction {
    QGHRegisterViewController *forgetPwdVC = [[QGHRegisterViewController alloc] initWithType:QGHRegisterViewTypeChangePwd];
    forgetPwdVC.bindPhoneSuccessBlock = ^(QGHRegisterModel *registerModel) {
        [self.navigationController popToViewController:self animated:YES];
    };
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}


- (void)strollButtonAction {

}


- (void)qqButtonAction {
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            MMHAccount *account = [[MMHAccount alloc] init];
            account.userToken = user.credential.token;
            account.userId = user.uid;
            account.username = user.nickname;
            account.nickname = user.nickname;
            account.avatar_url = user.icon;
            account.sex = (user.gender == SSDKGenderFemale) ? @"2" : @"1";
//            [[MMHAccountSession currentSession] accountDidLogin:account];
//            [[NSNotificationCenter defaultCenter] postNotificationName:MMHUserDidLoginNotification object:nil];
//            self.succeededHandler(account);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[MMHNetworkAdapter sharedAdapter] loginWithPhoneNumber:user.uid passCode:user.credential.token loginType:QGHLoginTypeQQ from:self succeededHandler:^(MMHAccount *account) {
                    if (self.succeededHandler) {
                        self.succeededHandler(account);
                    }
                    [self dismissViewControllerWithAnimation];
                } failedHandler:^(NSError *error) {
                    NSString *errorTips = [error localizedDescription];
                    if ([errorTips isEqualToString:@"no_bind"]) {
                        [self bindPhone:account loginType:QGHLoginTypeQQ];
                    }
                    [self.view showTipsWithError:error];
                }];
            });
        } else {
            NSLog(@"QQ登陆失败");
        }
    }];
}


- (void)weChatButtonAction {
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            MMHAccount *account = [[MMHAccount alloc] init];
            account.userToken = user.credential.token;
            account.userId = user.uid;
            account.username = user.nickname;
            account.nickname = user.nickname;
            account.avatar_url = user.icon;
            account.sex = (user.gender == SSDKGenderFemale) ? @"2" : @"1";
//            [[MMHAccountSession currentSession] accountDidLogin:account];
//            [[NSNotificationCenter defaultCenter] postNotificationName:MMHUserDidLoginNotification object:nil];
//            self.succeededHandler(account);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[MMHNetworkAdapter sharedAdapter] loginWithPhoneNumber:user.uid passCode:user.credential.token loginType:QGHLoginTypeWeChat from:self succeededHandler:^(MMHAccount *account) {
                    if (self.succeededHandler) {
                        self.succeededHandler(account);
                    }
                    [self dismissViewControllerWithAnimation];
                } failedHandler:^(NSError *error) {
                    NSString *errorTips = [error localizedDescription];
                    if ([errorTips isEqualToString:@"no_bind"]) {
                        [self bindPhone:account loginType:QGHLoginTypeWeChat];
                    }
                    [self.view showTipsWithError:error];
                }];
            });
        } else {
            NSLog(@"微信登陆失败");
        }
    }];
}


- (void)weiboButtonAction {
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            MMHAccount *account = [[MMHAccount alloc] init];
            account.userToken = user.credential.token;
            account.userId = user.uid;
            account.username = user.nickname;
            account.nickname = user.nickname;
            account.avatar_url = user.icon;
            account.sex = (user.gender == SSDKGenderFemale) ? @"2" : @"1";
            //            [[MMHAccountSession currentSession] accountDidLogin:account];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:MMHUserDidLoginNotification object:nil];
            //            self.succeededHandler(account);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[MMHNetworkAdapter sharedAdapter] loginWithPhoneNumber:user.uid passCode:user.credential.token loginType:QGHLoginTypeWeibo from:self succeededHandler:^(MMHAccount *account) {
                    if (self.succeededHandler) {
                        self.succeededHandler(account);
                    }
                    [self dismissViewControllerWithAnimation];
                } failedHandler:^(NSError *error) {
                    NSString *errorTips = [error localizedDescription];
                    if ([errorTips isEqualToString:@"no_bind"]) {
                        [self bindPhone:account loginType:QGHLoginTypeWeChat];
                    }
                    [self.view showTipsWithError:error];
                }];
            });
        } else {
            NSLog(@"微博登陆失败");
        }
    }];
}


- (void)bindPhone:(MMHAccount *)account loginType:(QGHLoginType)type {
    QGHRegisterViewController *registerVC = [[QGHRegisterViewController alloc] initWithType:QGHRegisterViewTypeBindPhone];
    registerVC.account = account;
    registerVC.loginType = type;
    registerVC.bindPhoneSuccessBlock = ^(QGHRegisterModel *registerModel) {
        [self.navigationController popToViewController:self animated:YES];
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}


@end

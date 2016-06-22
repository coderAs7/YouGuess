//
//  QGHRegisterViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/20.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHRegisterViewController.h"
#import "QiangGouHui-Swift.h"


@interface QGHRegisterViewController ()<VerificationCodeTimerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) QGHRegisterViewType type;
@property (nonatomic, strong) UIView *securityTipsView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextField *telTextField;
@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UIButton *getVerifyCodeButton;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UILabel *userProtocolLabel;

@end


@implementation QGHRegisterViewController


- (instancetype)initWithType:(QGHRegisterViewType)type {
    self = [super init];
    
    if (self) {
        _type = type;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [QGHAppearance backgroundColor];
    
    [self setNavigationBar];
    
    if (self.type == QGHRegisterViewTypeBindPhone) {
        [self makeSecurityTipsView];
    }
    
    [self makeInputView];
    [self makeCommitButton];
    
    if (self.type == QGHRegisterViewTypeNormal) {
        [self makeUserProtocolLabel];
    }
    
    [VerificationCodeTimer sharedTimer].delegate = self;
    [self updateVerifyCodeButtonState:[VerificationCodeTimer sharedTimer]];
}


- (void)setNavigationBar {
    switch (self.type) {
        case QGHRegisterViewTypeNormal: {
            self.title = @"快速注册";
            
            UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"去登录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
            self.navigationItem.rightBarButtonItem = rightBarItem;
            
            
            UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cart_ic"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
            self.navigationItem.leftBarButtonItem = leftBarItem;
            
            
            break;
        }
        case QGHRegisterViewTypeChangePwd: {
            self.title = @"修改密码";
            
            break;
        }
        case QGHRegisterViewTypeBindPhone: {
            self.title = @"绑定手机号";
            
            break;
        }
        default:
            break;
    }
}


- (void)makeSecurityTipsView {
    _securityTipsView = [[UIView alloc] initWithFrame:CGRectMake(72, (80 - 39) * 0.5, mmh_screen_width() - 144, 39)];
    _securityTipsView.backgroundColor = [UIColor whiteColor];
    _securityTipsView.layer.cornerRadius = 39 * 0.5;
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = F3;
    tipsLabel.textColor = C8;
    tipsLabel.text = @"为了您的账户安全请及时绑定手机";
    [tipsLabel sizeToFit];
    
    [_securityTipsView addSubview:tipsLabel];
    tipsLabel.center = CGPointMake(_securityTipsView.width * 0.5, _securityTipsView.height * 0.5);
    
    [self.view addSubview:_securityTipsView];
}


- (void)makeInputView {
    CGFloat originY = 10;
    if (self.type == QGHRegisterViewTypeBindPhone) {
        originY = 80;
    }
    
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, mmh_screen_width(), 144)];
    _inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_inputView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, 48, mmh_screen_width() - 30, 1)];
    line1.backgroundColor = [QGHAppearance backgroundColor];
    [_inputView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 96, mmh_screen_width() - 30, 1)];
    line2.backgroundColor = [QGHAppearance backgroundColor];
    [_inputView addSubview:line2];
    
    _getVerifyCodeButton = [[UIButton alloc] init];
    _getVerifyCodeButton.layer.cornerRadius = 5;
    _getVerifyCodeButton.layer.masksToBounds = YES;
    _getVerifyCodeButton.titleLabel.font = F3;
    [_getVerifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifyCodeButton setTitleColor:C20 forState:UIControlStateNormal];
    [_getVerifyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [_getVerifyCodeButton setBackgroundImage:[UIImage patternImageWithColor:[QGHAppearance themeColor]] forState:UIControlStateNormal];
    [_getVerifyCodeButton setBackgroundImage:[UIImage patternImageWithColor:C5] forState:UIControlStateDisabled];
    [_getVerifyCodeButton sizeToFit];
    [_getVerifyCodeButton setWidth:_getVerifyCodeButton.width + 20];
    [_getVerifyCodeButton setHeight:32];
    _getVerifyCodeButton.right = mmh_screen_width() - 15;
    _getVerifyCodeButton.centerY = _inputView.height * 0.5;
    [_getVerifyCodeButton addTarget:self action:@selector(getVerifyCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:_getVerifyCodeButton];
    
    _telTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, mmh_screen_width() - 30, 48)];
    _telTextField.font = F4;
    _telTextField.textColor = C7;
    _telTextField.placeholder = @"请输入手机号";
    _telTextField.clearButtonMode = UITextFieldViewModeAlways;
    _telTextField.delegate = self;
    [_inputView addSubview:_telTextField];
    
    _verifyCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 48, mmh_screen_width() - 30, 48)];
    [_verifyCodeTextField setMaxX:_getVerifyCodeButton.left - 15];
    _verifyCodeTextField.font = F4;
    _verifyCodeTextField.textColor = C7;
    _verifyCodeTextField.placeholder = @"请输入验证码";
    _verifyCodeTextField.delegate = self;
    [_inputView addSubview:_verifyCodeTextField];
    
    _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 96, mmh_screen_width() - 30, 48)];
    _pwdTextField.font = F4;
    _pwdTextField.textColor = C7;
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.placeholder = @"请输入登录密码";
    _pwdTextField.delegate = self;
    [_inputView addSubview:_pwdTextField];
}


- (void)makeCommitButton {
    _commitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, mmh_screen_width() - 30, 48)];
    [_commitButton attachToBottomSideOfView:_inputView byDistance:30];
    _commitButton.layer.cornerRadius = 5;
    _commitButton.layer.masksToBounds = YES;
    _commitButton.titleLabel.font = F8;
    [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_commitButton setTitleColor:C21 forState:UIControlStateNormal];
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [_commitButton setBackgroundImage:[UIImage patternImageWithColor:[QGHAppearance themeColor]] forState:UIControlStateNormal];
    [_commitButton setBackgroundImage:[UIImage patternImageWithColor:C3] forState:UIControlStateDisabled];
    [self.view addSubview:_commitButton];
}


- (void)makeUserProtocolLabel {
    _userProtocolLabel = [[UILabel alloc] init];
    _userProtocolLabel.font = F4;
    _userProtocolLabel.textColor = [UIColor lightGrayColor];
    NSString *colorString = @"《用户服务协议》";
    NSString *string = [NSString stringWithFormat:@"点击提交，即表示您接受%@", colorString];
    NSRange colorStringRange = [string rangeOfString:colorString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: [QGHAppearance themeColor]} range:colorStringRange];
    _userProtocolLabel.attributedText = attributedString;
    [_userProtocolLabel sizeToFit];
    _userProtocolLabel.y = _commitButton.bottom + 18;
    _userProtocolLabel.centerX = mmh_screen_width() * 0.5;
    [self.view addSubview:_userProtocolLabel];
}


#pragma mark - VerificationCodeTimerDelegate


- (void)verificationCodeTimerStepped:(VerificationCodeTimer *)timer {
    [self updateVerifyCodeButtonState:timer];
}


- (void)verificationCodeTimerFinished:(VerificationCodeTimer *)timer {
    [self updateVerifyCodeButtonState:timer];
}


- (void)updateVerifyCodeButtonState:(VerificationCodeTimer *)timer {
    NSTimeInterval remainingTime = [timer remainingTime];
    if (remainingTime > 0) {
        self.getVerifyCodeButton.enabled = NO;
        [self.getVerifyCodeButton setTitle:[NSString stringWithFormat:@"还剩%d秒", (int)remainingTime] forState:UIControlStateNormal];
    } else {
        self.getVerifyCodeButton.enabled = (self.telTextField.text.length == 11);
        [self.getVerifyCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
}


#pragma mark - UITextFieldDelegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    textField.text = text;
    
    if (self.telTextField.textLengh != 11) {
        self.getVerifyCodeButton.enabled = NO;
        self.commitButton.enabled = NO;
        return false;
    }
    
    [self updateVerifyCodeButtonState:[VerificationCodeTimer sharedTimer]];
    
    if (self.verifyCodeTextField.textLengh != 6) {
        self.commitButton.enabled = NO;
        return false;
    }
    
    if (self.pwdTextField.textLengh == 0) {
        self.commitButton.enabled = NO;
        return false;
    }
    
    self.commitButton.enabled = YES;
    return false;
}


#pragma mark - Actions


- (void)leftBarButtonItemAction {
    [self dismissViewControllerWithAnimation];
}


- (void)rightBarButtonItemAction {

}


- (void)getVerifyCodeButtonAction {
    [[VerificationCodeTimer sharedTimer] start];
}

@end

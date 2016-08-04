//
//  QGHCommentViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/8/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHCommentViewController.h"
#import "CWStarRateView.h"
#import "MMHNetworkAdapter+Order.h"
#import "QGHOrderListViewController.h"

@interface QGHCommentViewController ()

@property (nonatomic, strong) MMHImageView *imageView;
@property (nonatomic, strong) CWStarRateView *starView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *subButton;

@property (nonatomic, strong) QGHOrderProduct *orderProduct;
@property (nonatomic, copy) NSString *orderId;

@end

@implementation QGHCommentViewController


- (instancetype)initWithProduct:(QGHOrderProduct *)orderProduct orderId:(NSString *)orderId {
    self = [super init];
    
    if (self) {
        _orderProduct = orderProduct;
        _orderId = orderId;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表评价";
    
    _imageView = [[MMHImageView alloc] initWithFrame:CGRectMake(15, 20, 135, 135)];
    _imageView.layer.borderColor = C6.CGColor;
    _imageView.layer.borderWidth = 1;
    [_imageView updateViewWithImageAtURL:self.orderProduct.img_path];
    [self.view addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.right + 15, 20, mmh_screen_width() - 45 - 135, 0)];
    _titleLabel.textColor = C8;
    _titleLabel.font = F5;
    _titleLabel.text = self.orderProduct.good_name;
//    _titleLabel.preferredMaxLayoutWidth = mmh_screen_width() - 45;
    _titleLabel.numberOfLines = 3;
    [_titleLabel sizeToFit];
    [self.view addSubview:_titleLabel];
    
    _starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(165, _titleLabel.bottom + 15, mmh_screen_width() - 45 - 135, 30) numberOfStars:5];
    _starView.scorePercent = 0;
    _starView.allowIncompleteStar = NO;
    [self.view addSubview:_starView];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(15, _imageView.bottom + 20, mmh_screen_width() - 30, 80)];
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = C6.CGColor;
    [self.view addSubview:_backView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, _backView.width - 20, _backView.height - 20)];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _textField.textColor = C8;
    _textField.placeholder = @"评价一下这件宝贝，说点什么吧";
    _textField.font = F5;
    [_backView addSubview:_textField];
    
    _subButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 32)];
    _subButton.right = mmh_screen_width() - 15;
    _subButton.bottom = self.view.height - 15 - 64;
    [_subButton setTitleColor:C21 forState:UIControlStateNormal];
    _subButton.backgroundColor = C20;
    _subButton.layer.cornerRadius = 3;
    _subButton.titleLabel.font = F4;
    [_subButton setTitle:@"发表评价" forState:UIControlStateNormal];
    [_subButton addTarget:self action:@selector(subButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_subButton];
}


- (void)subButtonAction {
    if (self.textField.text.length == 0) {
        [self.view showTips:@"评价内容不能为空"];
        return;
    }
    
    [[MMHNetworkAdapter sharedAdapter] sendCommentForm:self orderId:self.orderId content:_textField.text star:(NSInteger)(self.starView.scorePercent / 0.2) succeededHandler:^{
        [self.view showTips:@"发表评价成功"];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QGHOrderListViewController class]]) {
                [(QGHOrderListViewController *)vc fetchData];
                break;
            }
        }
        [self.navigationController popToViewControllerOfClass:[QGHOrderListViewController class]];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}


@end

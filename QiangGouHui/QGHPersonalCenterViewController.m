//
//  QGHPersonalCenterViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/18.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHPersonalCenterViewController.h"
#import "MMHPersonalCenterAllOrderCell.h"
#import "QGHCommonCellTableViewCell.h"
#import "QGHLoginViewController.h"
#import "QGHPersonalInfoViewController.h"
#import "QGHOrderListViewController.h"


static NSString *QGHPersonalCenterCommonCellIdentifier = @"QGHPersonalCenterCommonCellIdentifier";
static NSString *QGHPersonalCenterOrderCellIdentifier = @"QGHPersonalCenterOrderCellIdentifier";


@interface QGHPersonalCenterViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIView *personalView;
@property (nonatomic, strong) MMHImageView *personalImage;
@property (nonatomic, strong) UILabel *personalNameLabel;

@end


@implementation QGHPersonalCenterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeTableView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"QGHCommonCellTableViewCell" bundle:nil] forCellReuseIdentifier:QGHPersonalCenterCommonCellIdentifier];
    [_tableView registerClass:[MMHPersonalCenterAllOrderCell class] forCellReuseIdentifier:QGHPersonalCenterOrderCellIdentifier];
    _tableView.tableHeaderView = [self personalCenterHeaderView];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}


- (UIView *)personalCenterHeaderView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 220)];
        _headerView.backgroundColor = [QGHAppearance themeColor];
        [_headerView addSubview:self.loginButton];
//        [_headerView addSubview:self.personalView];
    }
    
     return _headerView;
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QGHCommonCellTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:QGHPersonalCenterCommonCellIdentifier forIndexPath:indexPath];
            cell.title = @"我的订单";
            cell.subTitle = @"查看全部订单";
            
            return cell;
        } else {
            MMHPersonalCenterAllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHPersonalCenterOrderCellIdentifier forIndexPath:indexPath];
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            QGHCommonCellTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:QGHPersonalCenterCommonCellIdentifier forIndexPath:indexPath];
            cell.title = @"在线客服";
            cell.subTitle = @"400-400-400";
            
            return cell;
        } else {
            QGHCommonCellTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:QGHPersonalCenterCommonCellIdentifier forIndexPath:indexPath];
            cell.title = @"设置";
            cell.subTitle = @"";
            
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 44;
        } else {
            return 70;
        }
    } else {
        return 44;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QGHOrderListViewController *orderListVC = [[QGHOrderListViewController alloc] init];
            [self.navigationController pushViewController:orderListVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - Actions


- (void)loginButtonAction {

    [self presentLoginViewControllerWithSucceededHandler:^{
    }];
}


#pragma mark - getters and setters


- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        [_loginButton setCenterX:mmh_screen_width() * 0.5];
        [_loginButton setCenterY:220 * 0.5];
        _loginButton.layer.borderColor = [UIColor colorWithRed:106 / 255.0 green:69 / 255.0 blue:18 / 255.0 alpha:1].CGColor;
        _loginButton.layer.borderWidth = 1;
        _loginButton.layer.cornerRadius = 5;
        [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor colorWithRed:106 / 255.0 green:69 / 255.0 blue:18 / 255.0 alpha:1] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginButton;
}


- (UIView *)personalView {
    if (!_personalView) {
        _personalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), 100)];
        
        _personalImage = [[MMHImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        [_personalImage setCenterX:mmh_screen_width() * 0.5];
        _personalImage.layer.borderColor = [UIColor colorWithRed:106 / 255.0 green:69 / 255.0 blue:18 / 255.0 alpha:1].CGColor;
        _personalImage.layer.borderWidth = 1;
        _personalImage.layer.cornerRadius = 35;
        _personalImage.userInteractionEnabled = YES;
        __weak typeof(self) weakSelf = self;
        _personalImage.actionBlock = ^{
            QGHPersonalInfoViewController *personalInfoVC = [[QGHPersonalInfoViewController alloc] init];
            [weakSelf.navigationController pushViewController:personalInfoVC animated:YES];
        };
        [_personalView addSubview:_personalImage];
        
        _personalNameLabel = [[UILabel alloc] init];
        _personalNameLabel.textAlignment = NSTextAlignmentCenter;
        _personalNameLabel.font = F4;
        _personalNameLabel.text = @"宇宙第一帅";
        _personalNameLabel.textColor = C8;
        [_personalNameLabel sizeToFit];
        [_personalNameLabel setWidth:mmh_screen_width()];
        [_personalNameLabel setCenterX:mmh_screen_width() * 0.5];
        [_personalNameLabel attachToBottomSideOfView:_personalImage byDistance:10];
        [_personalView addSubview:_personalNameLabel];
        
        [_personalView setCenterY:220 * 0.5];
    }
    
    return _personalView;
}


@end

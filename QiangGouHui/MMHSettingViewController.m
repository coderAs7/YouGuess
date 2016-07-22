//
//  MMHSettingViewController.m
//  MamHao
//
//  Created by fishycx on 15/5/23.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHSettingViewController.h"
#import <StoreKit/StoreKit.h>                           // 应用内跳appstore

//#import "MMHPaySafetyPassCodeViewController.h"          // 支付安全
//#import "MMHNetworkAdapter+Center.h"                    // 接口

//#import "MMHSettingPaySettingModel.h"                   // 获取设置支付状态
//#import "MMHWebViewController.h"
//#import "LESAlertView.h"
#import "MMHAccountSession.h"
//#import "MMHCurrentLocationModel.h"                     // 地址信息
//#import "MMHImageTestViewController.h"

//#import "CRFProductDetailViewController.h"
//#import "MMHSwift.h"
//#import "TWTTweetDetailInfoViewController.h"
//#import "TWTPostTweetViewController.h"
//#import "MMHAccountSession.h"
//#import "MMHPersonalInfoModelManager.h"
//#import "MMHSelectAddressViewController.h"
//#import "MPTVIPCenterViewController.h"
//#import "MPTPayVIPSucceedViewController.h"
//#import "MPTCommentViewController.h"
//#import "MMHActionSheet.h"
//#import "MMHAction.h"
#import "MMHTableViewCell.h"
#import "MMHNetworkAdapter+Login.h"


NSString *const MMHSettingViewControllerMMHTableViewCellIdentifier = @"MMHSettingViewControllerMMHTableViewCellIdentifier";



@interface MMHSettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) MMHSettingPaySettingModel *paySettingModel;
@property (nonatomic, strong) NSArray *dataSourceArray;
@end


@implementation MMHSettingViewController


#pragma mark - getter method


- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
//        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MMHTableViewCell class] forCellReuseIdentifier:MMHSettingViewControllerMMHTableViewCellIdentifier];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view addSubview:self.tableView];
    if ([[MMHAccountSession currentSession] alreadyLoggedIn]) {
        self.dataSourceArray = @[@[@"修改密码"], @[@"意见反馈", @"关于我们"]];
    } else {
        self.dataSourceArray = @[@[@"意见反馈", @"关于我们"]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAction) name:MMHUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutAction) name:MMHUserDidLogoutNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - private method


//- (void)arrayWithInit {
//    self.paySettingModel = [[MMHSettingPaySettingModel alloc] init];
//}


- (NSString *)sectionNameForSection:(NSInteger)section {
    NSString *sectionName = self.dataSourceArray[section];
    if ([sectionName isKindOfClass:[NSString class]]) {
        return self.dataSourceArray[section];
    }
    
    return nil;
}

- (NSString *)cellNameForIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowDataArr = self.dataSourceArray[indexPath.section];
    if ([rowDataArr isKindOfClass:[NSArray class]]) {
        return rowDataArr[indexPath.row];
    }
    
    return nil;
}



#pragma mark - private method


-(void)handleQuitBtn:(UIButton *)sender{
    AppAlertViewController *alert = [[AppAlertViewController alloc] initWithParentController:self];
    [alert showAlert:nil message:@"确认退出当前帐号？" sureTitle:@"确定" cancelTitle:@"取消" sure:^{
        [[MMHNetworkAdapter sharedAdapter] logoutWithRequester:self succeededHandler:^{
            [self.navigationController popViewControllerAnimated:YES];
        } failedHandler:^(NSError *error) {
            [self.view showTipsWithError:error];
        }];
    } cancel:^{
        //
    }];
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = self.dataSourceArray[section];
    return rows.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MMHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MMHSettingViewControllerMMHTableViewCellIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.left = 10;
    cell.titleLabel.font = F5;
    cell.titleLabel.textColor = C8;
    cell.detailLabel.textColor = C7;
    cell.detailLabel.font = F4;
    cell.showArrow = YES;
    if ([[self cellNameForIndexPath:indexPath] isEqualToString:@"修改密码"]){            // 设置密码
        [cell.titleLabel setSingleLineText:@"修改密码"];
    } else if ([[self cellNameForIndexPath:indexPath] isEqualToString:@"意见反馈"]){
        [cell.titleLabel setSingleLineText:@"意见反馈"];
    } else if ([[self cellNameForIndexPath:indexPath] isEqualToString:@"关于我们"]){
        [cell.titleLabel setSingleLineText:@"关于我们"];
       NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [cell.detailLabel setSingleLineText:[NSString stringWithFormat:@"V%@", version]];
    }

    return cell;
}


#pragma mark - UITableViewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[self cellNameForIndexPath:indexPath] isEqualToString:@"重置支付密码"]){     // 设置
        
        
    } else if ([[self cellNameForIndexPath:indexPath] isEqualToString:@"给妈妈好评分"]){
        
    } else if ([[self cellNameForIndexPath:indexPath] isEqualToString:@"关于妈妈好"]) {
        
    }

}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1 && indexPath.row == 1) {
//        [cell addSeparatorLineWithType:SeparatorTypeBottom];
//    }else{
//    
//        [cell addSeparatorLineWithType:SeparatorTypeSingle];
//    }
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.backgroundColor = [UIColor clearColor];
    if (section == 1) {
        UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, mmh_screen_width() - 20, 44)];
        quitButton.backgroundColor = C20;
        [quitButton setTitleColor:C21 forState:UIControlStateNormal];
        quitButton.clipsToBounds = YES;
        quitButton.layer.cornerRadius = 5.0f;
        quitButton.titleLabel.font = F6;
        quitButton.y = 25.0f;
        [quitButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [quitButton addTarget:self action:@selector(handleQuitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:quitButton];
        if ([[MMHAccountSession currentSession] alreadyLoggedIn]) {
            quitButton.hidden = NO;
        } else {
            quitButton.hidden = YES;
        }
    }
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0f;
    }
    return 69;
}


//#pragma mark - 接口
//-(void)sendRequestWithGetSettingStatus{
//    __weak typeof(self)weakSelf = self;
//    [[MMHNetworkAdapter sharedAdapter]sendRequestGetIsSettingPayPasswordFrom:nil succeededHandler:^(MMHSettingPaySettingModel *paySettedModel) {
//        if (!weakSelf){
//            return ;
//        }
//        __strong typeof(weakSelf)strongSelf = weakSelf;
//        strongSelf.paySettingModel = paySettedModel;
//        // 刷新tableView
//        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    } failedHandler:^(NSError *error) {
//        if (!weakSelf){
//            return ;
//        }
//        __strong typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf.view showTipsWithError:error];
//    }];
//}

#pragma mark 清除当前位置信息
//-(void)clearNormalLocationInfo{
////    [MMHCurrentLocationModel sharedLocation].deliveryAddrId = @"";           // 区域id
////    [MMHCurrentLocationModel sharedLocation].receiptProvince = @"";
////    [MMHCurrentLocationModel sharedLocation].receiptCity = @"";
////    [MMHCurrentLocationModel sharedLocation].receiptArea = @"";
////    [MMHCurrentLocationModel sharedLocation].receiptAreaId = @"";
////    [MMHCurrentLocationModel sharedLocation].receiptLat =  0;
////    [MMHCurrentLocationModel sharedLocation].receiptLng =  0;
//    [MMHCurrentLocationModel sharedLocation].receiptAddressSingleModel = nil;
//}

//905157044

#pragma mark - Action


- (void)loginAction {
    [self.tableView reloadData];
}

- (void)logoutAction {
    [self.tableView reloadData];
}


@end

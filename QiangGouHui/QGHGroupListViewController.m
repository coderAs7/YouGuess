//
//  QGHGroupListViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/19.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHGroupListViewController.h"
#import "MMHNetworkAdapter+Chat.h"
#import "QGHGroupModel.h"
#import "EMClient.h"
#import "QGHGroupCell.h"
#import "QGHChatViewController.h"


static NSString *const QGHGroupCellIdentifier = @"QGHGroupCellIdentifier";
static NSString *const QGHGroupTitleCellIdentifier = @"QGHGroupTitleCellIdentifier";


@interface QGHGroupListViewController ()<EMGroupManagerDelegate, UITableViewDataSource, UITableViewDelegate, QGHGroupCellDelegate, QGHChatViewControllerDelegate>

@property (nonatomic, strong) NSArray<QGHGroupModel *> *allGroupArr;
@property (nonatomic, strong) NSMutableArray<QGHGroupModel *> *myGroupArr;
@property (nonatomic, strong) NSMutableArray<QGHGroupModel *> *recommendGroupArr;
@property (nonatomic, strong) NSArray<EMGroup *> *emGroupArr;

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation QGHGroupListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myGroupArr = [[NSMutableArray alloc] init];
    self.recommendGroupArr = [[NSMutableArray alloc] init];
    
    [self makeTableView];
    
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification) name:MMHUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification) name:MMHUserDidLogoutNotification object:nil];
    
    NSString *prefix = @"{\"item\":{";
    NSLog(@"fuck:%@", prefix);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchServerGroup];
    [self fetchEMGroup];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHGroupCell" bundle:nil] forCellReuseIdentifier:QGHGroupCellIdentifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:QGHGroupTitleCellIdentifier];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.and.left.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.tableView];
}


- (void)fetchServerGroup {
    self.allGroupArr = nil;
    [[MMHNetworkAdapter sharedAdapter] fetchGroupListFrom:self succeededHandler:^(NSArray *groupArr){
        self.allGroupArr = groupArr;
        [self configureGroupArr];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


- (void)fetchEMGroup {
    self.emGroupArr = nil;
    if ([[EMClient sharedClient] isConnected] && [[EMClient sharedClient] isLoggedIn]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            EMError *error = nil;
            self.emGroupArr = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
            [self configureGroupArr];
        });
    }
}


- (void)configureGroupArr {
    if (!self.allGroupArr) {
        return;
    }
    
    if (!self.emGroupArr) {
        return;
    }
    
    [self.myGroupArr removeAllObjects];
    [self.recommendGroupArr removeAllObjects];
    for (QGHGroupModel *groupModel in self.allGroupArr) {
        BOOL isMyGroup = NO;
        for (EMGroup *emGroup in self.emGroupArr) {
            if ([groupModel.room_id isEqualToString:emGroup.groupId]) {
                [self.myGroupArr addObject:groupModel];
                isMyGroup = YES;
                groupModel.isMyGroup = YES;
                break;
            }
        }
        
        if (!isMyGroup) {
            [self.recommendGroupArr addObject:groupModel];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.myGroupArr.count + 1;
    } else {
        return self.recommendGroupArr.count + 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHGroupTitleCellIdentifier];
            cell.textLabel.font = F5;
            cell.textLabel.text = @"我的热聊群";
            cell.textLabel.textColor = C7;
            
            return cell;
        } else {
            QGHGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHGroupCellIdentifier];
            QGHGroupModel *model = self.myGroupArr[indexPath.row - 1];
            [cell setGroupModel:model];
            cell.showJoinButton = NO;
            
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHGroupTitleCellIdentifier];
            cell.textLabel.font = F5;
            cell.textLabel.text = @"猜你喜欢";
            cell.textLabel.textColor = C7;
            
            return cell;
        } else {
            QGHGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHGroupCellIdentifier];
            QGHGroupModel *model = self.recommendGroupArr[indexPath.row - 1];
            [cell setGroupModel:model];
            cell.delegate = self;
            cell.showJoinButton = YES;
            
            return cell;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QGHGroupModel *model = self.myGroupArr[indexPath.row - 1];
        
        [[EMClient sharedClient].groupManager asyncFetchGroupInfo:model.room_id includeMembersList:YES success:^(EMGroup *aGroup) {
            NSString *userIds = [NSString stringSeparateByCommaFromArray:aGroup.members];
            [[MMHNetworkAdapter sharedAdapter] fetchGroupUserListFrom:self userIds:userIds succeededHandler:^(NSArray<QGHGroupUserModel *> *groupUserArr) {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[QGHChatViewController class]]) {
                        return;
                    }
                }
                
                QGHChatViewController *messageVC = [[QGHChatViewController alloc] initWithGroupId:model.room_id UserArr:groupUserArr];
                messageVC.title = model.nickname;
                messageVC.customChatType = QGHChatTypeGroup;
                messageVC.chatDelegate = self;
                messageVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:messageVC animated:YES];
            } failedHandler:^(NSError *error) {
                //nothing
            }];
        } failure:^(EMError *aError) {
            //nothing
        }];
        
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    } else {
        return 80;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}


#pragma mark - QGHGroupCellDelgate


- (void)groupCellJoin:(QGHGroupModel *)model {
    EMError *error;
    [[EMClient sharedClient].groupManager joinPublicGroup:model.room_id error:&error];
    NSLog(@"fuck:%@", error.errorDescription);
    
    [self fetchServerGroup];
    [self fetchEMGroup];
}


#pragma mark - QGHChatViewControllerDelegate


- (void)chatViewControllerLeaveGroupSuccess {
    [self.navigationController popToViewController:self animated:YES];
    
    [self fetchServerGroup];
    [self fetchEMGroup];
}


#pragma mark - Actions


- (void)loginNotification {
    [self fetchEMGroup];
}


- (void)logoutNotification {
    self.allGroupArr = nil;
    self.emGroupArr = nil;
    [self.myGroupArr removeAllObjects];
    [self.recommendGroupArr removeAllObjects];
    [self.tableView reloadData];
}

@end

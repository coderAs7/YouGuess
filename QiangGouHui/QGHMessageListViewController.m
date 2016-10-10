//
//  QGHMessageListViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/11.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHMessageListViewController.h"
#import "EMSDK.h"
#import "QGHGroupModel.h"
#import "MMHNetworkAdapter+Chat.h"
#import "QGHConversation.h"
#import "IMessageModel.h"
#import "EaseMessageModel.h"
#import "QGHMessageListCell.h"
#import "QGHChatViewController.h"


@interface QGHMessageListViewController ()<UITableViewDataSource, UITableViewDelegate, QGHChatViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<EMConversation *> *conversations;
@property (nonatomic, strong) NSArray<QGHGroupModel *> *allGroupArr;
@property (nonatomic, strong) NSMutableArray<QGHConversation *> *qghConversations;

@end


@implementation QGHMessageListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天";
    
    [self makeTableView];
    
    _qghConversations = [NSMutableArray array];
    _conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    [self fetchServerGroup];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.and.left.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.tableView];
}


- (void)fetchServerGroup {
    self.allGroupArr = nil;
    [[MMHNetworkAdapter sharedAdapter] fetchGroupListFrom:self succeededHandler:^(NSArray *groupArr){
        self.allGroupArr = groupArr;
        [self configureConversations];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


- (void)configureConversations {
    for (EMConversation *conversation in self.conversations) {
        BOOL isGroup = NO;
        QGHConversation *qghConversation = [[QGHConversation alloc] init];
        qghConversation.conversationID = conversation.conversationId;
        qghConversation.message = conversation.latestMessage;
        qghConversation.unReadMsgCount = [conversation unreadMessagesCount];
        
        for (QGHGroupModel *group in self.allGroupArr) {
            if ([group.room_id isEqualToString:conversation.conversationId]) {
                isGroup = YES;
                qghConversation.conversationName = group.nickname;
                qghConversation.conversationImgUrl = group.avatar_url;
                break;
            }
        }
        
        if (!isGroup) {
            qghConversation.conversationName = @"客服";
            qghConversation.conversationImg = [UIImage imageNamed:@"default_avatar"];
        }
        
        [_qghConversations addObject:qghConversation];
    }
    [self.tableView reloadData];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.qghConversations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    QGHMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
//        cell = [[QGHMessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QGHMessageListCell" owner:self options:nil] lastObject];
    }
    cell.conversation = self.qghConversations[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHConversation *conversation = self.qghConversations[indexPath.row];
    NSString *conversationId = conversation.conversationID;
    conversation.unReadMsgCount = 0;
    [tableView reloadData];
    
    if (conversation.message.chatType == EMChatTypeChat) {
        QGHChatViewController *messageVC = [[QGHChatViewController alloc] initWithConversationChatter:conversationId conversationType:EMConversationTypeChat];
        messageVC.customChatType = QGHChatTypeChat;
        [self.navigationController pushViewController:messageVC animated:YES];
    } else {
        [[EMClient sharedClient].groupManager asyncFetchGroupInfo:conversationId includeMembersList:YES success:^(EMGroup *aGroup) {
            NSString *userIds = [NSString stringSeparateByCommaFromArray:aGroup.members];
            [[MMHNetworkAdapter sharedAdapter] fetchGroupUserListFrom:self userIds:userIds succeededHandler:^(NSArray<QGHGroupUserModel *> *groupUserArr) {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[QGHChatViewController class]]) {
                        return;
                    }
                }
                
                QGHChatViewController *messageVC = [[QGHChatViewController alloc] initWithGroupId:conversationId UserArr:groupUserArr];
                messageVC.title = self.qghConversations[indexPath.row].conversationName;
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
    return 80;
}


- (void)chatViewControllerLeaveGroupSuccess {
    [self.navigationController popToViewController:self animated:YES];
    
    [_qghConversations removeAllObjects];
    _conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    [self fetchServerGroup];
}


@end

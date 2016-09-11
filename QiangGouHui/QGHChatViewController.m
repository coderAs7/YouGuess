//
//  QGHChatViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/31.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHChatViewController.h"
#import "EaseUI.h"
#import "QGHGroupHandleViewController.h"
#import "EMClient.h"
#import "QGHProductInfoMessageCell.h"
#import "MMHNetworkAdapter+Chat.h"


@interface QGHChatViewController ()<QGHGroupHandleViewControllerDelegate, EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@property (nonatomic, strong) QGHProductInfo *productInfo;
@property (nonatomic, strong) NSArray<QGHGroupUserModel *> *userArr;

@end


@implementation QGHChatViewController


- (instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationType:(EMConversationType)conversationType {
    self = [super initWithConversationChatter:conversationChatter conversationType:conversationType];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}


- (instancetype)initWithProductInfo:(QGHProductInfo *)info {
    if(![[EMClient sharedClient] isConnected] || ![[EMClient sharedClient] isLoggedIn]){
        return nil;
    }
    
    NSString *chatter = info.supplier;
    if (chatter.length == 0) {
        chatter = @"kefu";
    }
    self = [self initWithConversationChatter:chatter conversationType:EMConversationTypeChat];
    if (self) {
        _productInfo = info;
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}


- (instancetype)initWithGroupId:(NSString *)groupId UserArr:(NSArray<QGHGroupUserModel *> *)userArr {
    self = [super initWithConversationChatter:groupId conversationType:EMConversationTypeGroupChat];
    if (self) {
        self.userArr = userArr;
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    
    EaseEmotionManager *manager= [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:[EaseEmoji allEmoji]];
    [self.faceView setEmotionManagers:@[manager]];
    
    [self setNavigationBar];
    
    if (self.productInfo) {
        [self sendTextMessage:[self getProductInfoJson]];
    }
    
    if (self.customChatType) {
        [[EMClient sharedClient].groupManager asyncFetchGroupInfo:self.conversation.conversationId includeMembersList:YES success:^(EMGroup *aGroup) {
            NSString *userIds = [NSString stringSeparateByCommaFromArray:aGroup.members];
            [[MMHNetworkAdapter sharedAdapter] fetchGroupUserListFrom:self userIds:userIds succeededHandler:^(NSArray<QGHGroupUserModel *> *groupUserArr) {
                self.userArr = groupUserArr;
//                [self reloadConversation];
                [self.tableView reloadData];
            } failedHandler:^(NSError *error) {
                //nothing
            }];
        } failure:^(EMError *aError) {
            //nothing
        }];
        
    }
    
    if (self.transferOrderNo) {
        [self sendTextMessage:[NSString stringWithFormat:@"用户申请退款 (订单号%@)", self.transferOrderNo]];
    }
}


- (void)setNavigationBar {
    UIBarButtonItem *goBackItem = [UIBarButtonItem itemWithImageName:@"basc_nav_back"
                                                highlightedImageName:nil
                                                               title:nil
                                                              target:self
                                                              action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItems = @[goBackItem];
    
    switch (self.customChatType) {
        case QGHChatTypeChat: {
            UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clearAction)];
            self.navigationItem.rightBarButtonItem = clearItem;
            break;
        }
        case QGHChatTypeGroup: {
            UIBarButtonItem *personalItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_btn_personal"] style:UIBarButtonItemStylePlain target:self action:@selector(personalAction)];
            self.navigationItem.rightBarButtonItem = personalItem;
            break;
        }
        default:
            break;
    }
}


- (void)fetchUserInfo {

}


#pragma mark - QGHGroupHandleViewControllerDelegate


- (void)groupHandleViewControllerClearChatRecord {
    [self removeAllMessages];
    [self.view showTips:@"删除消息记录成功"];
    [self.navigationController popToViewController:self animated:YES];
}


- (void)groupHandleViewControllerClearExitGroup {
    [self.navigationController popToViewController:self animated:YES];
    
    [self.view showProcessingView];
    [[EMClient sharedClient].groupManager asyncLeaveGroup:self.conversation.conversationId success:^(EMGroup *aGroup) {
        [self.view showTips:@"退群成功"];
        if ([self.chatDelegate respondsToSelector:@selector(chatViewControllerLeaveGroupSuccess)]) {
            [self.chatDelegate chatViewControllerLeaveGroupSuccess];
        }
    } failure:^(EMError *aError) {
        [self.view hideProcessingView];
        [self.view showTips:@"退群失败"];
    }];
}


#pragma mrak - EMChatToolbarDelegate


- (void)didSelectImageAction {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takeAlbum];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //TODO
    }];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:cancelAction];
    
    [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
}


#pragma mark - EaseMessageViewControllerDelegate


- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)model
{
    if (model.bodyType == EMMessageBodyTypeText) {
        NSString *CellIdentifier = [QGHProductInfoMessageCell cellIdentifierWithModel:model];
        
        QGHProductInfoMessageCell *sendCell = (QGHProductInfoMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[QGHProductInfoMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        sendCell.model = model;
        return sendCell;
    }
    
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    return [QGHProductInfoMessageCell cellHeightWithModel:messageModel];
}


- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    NSString *userId = message.from;


    if (self.customChatType == QGHChatTypeGroup) {
        for (QGHGroupUserModel *groupUser in self.userArr) {
            if ([groupUser.userId isEqualToString:userId]) {
                model.avatarURLPath = groupUser.avatar_url;
                model.nickname = groupUser.nickname;
                break;
            }
        }
    } else {
        if (model.isSender) {
            model.avatarURLPath = [[MMHAccountSession currentSession] avatar];
            model.nickname = [[MMHAccountSession currentSession] nickname];
        } else {
            model.avatarImage = [UIImage imageNamed:@"default_avatar"];
        }
    }
    
    
    return model;
}


#pragma mark - Actions


- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clearAction {
    [self removeAllMessages];
}


- (void)personalAction {
    QGHGroupHandleViewController *groupHandleVC = [[QGHGroupHandleViewController alloc] init];
    groupHandleVC.delegate = self;
    [self.navigationController pushViewController:groupHandleVC animated:YES];
}

- (void)takeAlbum {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}


- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        AppAlertViewController *alert = [[AppAlertViewController alloc] initWithParentController:self];
        [alert showAlert:@"提示" message:@"当前相机不可用" sureTitle:nil cancelTitle:@"确定" sure:nil cancel:nil];
    }
}


#pragma mark - private methods


- (NSString *)getProductInfoJson {
    NSDictionary *productDict = @{@"itemId": self.productInfo.goodsId, @"itemName": self.productInfo.title, @"pic": self.productInfo.img_path.firstObject, @"price": self.productInfo.discount_price};
    NSDictionary *jsonDict = @{@"item": productDict};
    
    return [jsonDict mmh_JSONString];
}


@end

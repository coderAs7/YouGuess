//
//  AppDelegate+EaseMob.m
//
//
//  Created by stone on 15/7/2.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "EaseUI.h"
#import "EMChatManagerDelegate.h"
#import "MMHAccountSession.h"

@implementation AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _connectionState = EMConnectionConnected;
//    APPLOG(@"%@",EaseMob_push_production);
    
    //    [[EMClient shareClient] registerSDKWithAppKey:]
    
    EMOptions *options = [EMOptions optionsWithAppkey:EaseMob_key];
    options.apnsCertName = EaseMob_push_production;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [self registerEaseMobNotification];
    [self setupNotifiers];
    
//    APPLOG(@"%@",[EMClient sharedClient].version);
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EMClient sharedClient] removeDelegate:self];
}

//// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    //
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}


//#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[EMClient sharedClient] applicationDidEnterBackground:notif.object];
}


- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationWillEnterForeground:notif.object];
}


#pragma mark - EMClientDelegate

- (void)didAutoLoginWithError:(EMError *)aError {
    if (aError) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLogout object:@NO];
    }
    else{
        //获取群组列表
        [[EMClient sharedClient].groupManager asyncGetMyGroupsFromServer:^(NSArray *aList) {
            //
        } failure:^(EMError *aError) {
            //
        }];
    }
}


#pragma mark - 收到消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    //判断app是否在后台 然后发起一个本地通知
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive
        || [UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        id<IMessageModel> model = [[EaseMessageModel alloc] initWithMessage:aMessages.lastObject];
        NSDictionary *messageExt = ((EMMessage *)aMessages.lastObject).ext;
        NSString *name = [messageExt objectForKey:@"name"];
        //        NSDictionary *apns = [messageExt objectForKey:@"em_apns_ext"];
        NSString *content;
        if (model.bodyType == EMMessageBodyTypeImage) {
            content = [NSString stringWithFormat:@"%@ 在讨论组中发了一张图片",name];
        }else if(model.bodyType == EMMessageBodyTypeVoice){
            content = [NSString stringWithFormat:@"%@ 在讨论组中发了一段语音",name];
        }else{
            if([content rangeOfString:@"img:"].location != NSNotFound){
                content = [NSString stringWithFormat:@"%@ 在讨论组中发了一张图片",name];
            }else{
                content = [NSString stringWithFormat:@"%@:%@",name, model.text];
            }
        }
        
        UILocalNotification *notifi = [[UILocalNotification alloc] init];
        notifi.fireDate = [NSDate new];
        notifi.repeatInterval = 0;
        notifi.applicationIconBadgeNumber = 1;
        notifi.soundName = UILocalNotificationDefaultSoundName;
        notifi.alertBody = content;
        notifi.userInfo = @{@"type" :@"message" };
        [[UIApplication sharedApplication] scheduleLocalNotification:notifi];
//        [NS_NOTIFICATION_CENTER postNotificationName:kNotification_refreshMessage object:nil];
    }else{
//        [NS_NOTIFICATION_CENTER postNotificationName:kNotification_refreshMessage object:nil];
    }
}


// 好友申请回调
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    //    if (!username) {
    //        return;
    //    }
    //    if (!message) {
    //        message = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
    //    }
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    //    [[ApplyViewController shareController] addNewApply:dic];
    //    if (self.mainController) {
    //        [self.mainController setupUntreatedApplyCount];
    //    }
}

// 离开群组回调
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    //    NSString *tmpStr = group.groupSubject;
    //    NSString *str;
    //    if (!tmpStr || tmpStr.length == 0) {
    //        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
    //        for (EMGroup *obj in groupArray) {
    //            if ([obj.groupId isEqualToString:group.groupId]) {
    //                tmpStr = obj.groupSubject;
    //                break;
    //            }
    //        }
    //    }
    //
    //    if (reason == eGroupLeaveReason_BeRemoved) {
    //        str = [NSString stringWithFormat:NSLocalizedString(@"group.beKicked", @"you have been kicked out from the group of \'%@\'"), tmpStr];
    //    }
    //    if (str.length > 0) {
    //                TTAlertNoTitle(str);
    //    }
}

// 申请加入群组被拒绝回调
- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
                                   groupname:(NSString *)groupname
                                      reason:(NSString *)reason
                                       error:(EMError *)error{
    //    if (!reason || reason.length == 0) {
    //        reason = [NSString stringWithFormat:NSLocalizedString(@"group.beRefusedToJoin", @"be refused to join the group\'%@\'"), groupname];
    //    }
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:reason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    //    [alertView show];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    //    if (!groupId || !username) {
    //        return;
    //    }
    //
    //    if (!reason || reason.length == 0) {
    //        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoin", @"%@ apply to join groups\'%@\'"), username, groupname];
    //    }
    //    else{
    //        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoinWithName", @"%@ apply to join groups\'%@\'：%@"), username, groupname, reason];
    //    }
    //
    //    if (error) {
    //        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.sendApplyFail", @"send application failure:%@\nreason：%@"), reason, error.description];
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    //        [alertView show];
    //    }
    //    else{
    //        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
    //        [[ApplyViewController shareController] addNewApply:dic];
    //        if (self.mainController) {
    //            [self.mainController setupUntreatedApplyCount];
    //        }
    //    }
}

// 已经同意并且加入群组后的回调
//- (void)didAcceptInvitationFromGroup:(EMGroup *)group
//                               error:(EMError *)error
//{
//    if(error)
//    {
//        return;
//    }
//
//    NSString *groupTag = group.groupSubject;
//    if ([groupTag length] == 0) {
//        groupTag = group.groupId;
//    }

//    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed and joined the group of \'%@\'"), groupTag];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
//}


// 绑定deviceToken回调
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        //        TTAlertNoTitle(NSLocalizedString(@"apns.failToBindDeviceToken", @"Fail to bind device token"));
    }
}


#pragma mark - 被其它设备登录后
- (void)didLoginFromOtherDevice
{
    //业务上也要登出操作
//    [NS_NOTIFICATION_CENTER  postNotificationName:kNotificationLogout object:nil userInfo:@{@"flag" : @"1"}];
}


// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState {
    _connectionState = aConnectionState;
}


- (void)didRemovedFromServer
{
//    APPLOG(@"被服务端删除");
//    [NS_NOTIFICATION_CENTER  postNotificationName:kNotificationLogout object:nil userInfo:@{@"flag" : @"2"}];
}


#pragma mark - 接受完离线消息后
- (void)didFinishedReceiveOfflineMessages
{
//    [NS_NOTIFICATION_CENTER postNotificationName:kNotification_refreshMessage object:nil];
}


@end

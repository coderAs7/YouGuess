//
//  MMHAccountSession.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/9.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

//#import <EaseMobSDK/EaseMob.h>
#import "MMHAccountSession.h"
#import "MMHAccount.h"
#import "MMHNetworkAdapter.h"
#import "MMHNetworkAdapter+Login.h"


#define MMHAccountSessionAccountPath [MMHPathDocuments() stringByAppendingPathComponent:@"account.plist"]


//NSString *const MMHAccountSessionChattingUserInfo = @"MMHAccountSessionChattingUserInfo";


@interface MMHAccountSession ()

@property (nonatomic, strong) MMHAccount *account;

@end


@implementation MMHAccountSession


+ (MMHAccountSession *)currentSession
{
    static MMHAccountSession *_currentSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentSession = [[self alloc] init];
    });
    return _currentSession;
}


+ (void)start
{
    MMHAccount *lastAccount = [self lastAccount];
    if (lastAccount == nil) {
        return;
    }
    
    if ([lastAccount isActivated]) {
        [self currentSession].account = lastAccount;
//        [[MMHPersonalInfoModelManager shareManager] fetchPersonalInfoWithCallback:^(BOOL isPerfectInfo, BOOL succeeded) {
//            
//        }];
    }

//    if ([lastAccount shouldAutoLogin]) {
//        [self currentSession].account = lastAccount;
//        [[self currentSession] startLogin];
//        return;
//    }
}


- (void)saveLastAccount:(MMHAccount *)account
{
    if (account == nil) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:MMHAccountSessionAccountPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:MMHAccountSessionAccountPath error:nil];
        }
        return;
    }

    NSString *path = MMHAccountSessionAccountPath;
    [NSKeyedArchiver archiveRootObject:account toFile:path];
}


+ (MMHAccount *)lastAccount
{
    NSString *path = MMHAccountSessionAccountPath;
    if (![[NSFileManager defaultManager] fileExistsAtPath:MMHAccountSessionAccountPath]) {
        return nil;
    }
    MMHAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return account;
}


- (void)accountDidLogin:(MMHAccount *)account
{
    [self saveLastAccount:account];
    self.account = account;
    self.isLoggingIn = NO;
//    [MMHSocialLoginAdapter logout];
}


- (BOOL)hasAnyAccountLoggedInOrLoggingIn
{
    if (!self.account) {
        return NO;
    }
    if ([self.account isActivated]) {
        return YES;
    }
    return self.isLoggingIn;
}


- (BOOL)alreadyLoggedIn
{
    if (!self.account) {
        return NO;
    }
    if ([self.account isActivated]) {
        return YES;
    }
    return !self.isLoggingIn;
}


- (nullable NSString *)userId
{
    if (self.account) {
        return self.account.userId;
    }
    return nil;
}


- (NSString *)username
{
    if (self.account) {
        return self.account.username;
    }
    return nil;
}


- (NSString *)token {
    if (self.account) {
        return self.account.userToken;
    }
    return nil;
}

- (NSString *)avatar {
    if (self.account) {
        if (self.account.avatar_url.length != 0) {
            return self.account.avatar_url;
        }
    }
    return nil;
}


- (NSString *)nickname {
    if (self.account) {
        if (self.account.nickname.length != 0) {
            return self.account.nickname;
        }
    }
    return @"";
}


- (void)logoutWithCompletion:(void (^)(BOOL succeeded))completion
{
//    [[MMHSocialLoginAdapter sharedAdapter] logout];
    self.account = nil;
    [self saveLastAccount:nil];
//    [[self class] setChattingUserInfo:nil];
//    [self deleteFileAtPath:[self favoritesFilePath]];
//    [MMHCartData removeCartID];
//    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
//        if (completion) {
//            completion(YES);
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:MMHUserDidLogoutNotification
//                                                            object:nil
//                                                          userInfo:nil];
//    } onQueue:nil];
}


//- (NSString *)favoritesFilePath {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *doucumentsDirectory = paths.lastObject;
//    NSString *filePath = [doucumentsDirectory stringByAppendingPathComponent:@"collect.plist"];
//    
//    return filePath;
//}


- (void)deleteFileAtPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSMutableArray *offLineData = [NSMutableArray arrayWithContentsOfFile:path];
        [offLineData removeAllObjects];
        [offLineData writeToFile:path atomically:YES];
    }
    else {
        //
    }
}

//
//- (void)updatePeronalInfoModel:(MMHPersonalInfoModel *)personalInfoModel {
//    if (!self.account) {
//        return;
//    }
//    
//    if (personalInfoModel.memberId.length == 0) {
//        return;
//    }
//    
//    if (![self.account.memberID isEqualToString:personalInfoModel.memberId]) {
//        return;
//    }
//    
//    self.account.nickname = personalInfoModel.nickname;
//    self.account.avatar = personalInfoModel.avatar;
//    [self saveLastAccount:self.account];
//
//}


//- (void)updateMemberInfoWithMemberCenterInfo:(MMHMemberCenterInfoModel *)memberCenterInfo {
//    if (!self.account) {
//        return;
//    }
//    
//    if (memberCenterInfo.memberId.length == 0) {
//        return;
//    }
//
//    if (![self.account.memberID isEqualToString:memberCenterInfo.memberId]) {
//        return;
//    }
//
//    self.account.avatar = memberCenterInfo.headPic;
//    self.account.nickname = memberCenterInfo.nickName;
//    [self saveLastAccount:self.account];
//}


//- (void)updatePersonInfoWithPerCenterInfo:(MMHPersonalCenterInfoModel *)personCenterInfo {
//    if (!self.account) {
//        return;
//    }
//    
//    self.account.openPromotionCenter = personCenterInfo.openPromotionCenter;
//    self.account.promoterType = personCenterInfo.promoterType;
//    self.account.promotionDomain = personCenterInfo.shareDomain;
//    
//    self.account.openCloudCenter = personCenterInfo.openCloudCenter;
//    self.account.cloudCenterLoginUrl = personCenterInfo.cloudCenterLoginUrl;
//}

@end


//@implementation MMHAccountSession (Cart)
//
//
//- (MMHID)cartID
//{
//    if (!self.account) {
//        return 0;
//    }
//    
//    if (self.isLoggingIn) {
//        return 0;
//    }
//    
//    return self.account.cartID;
//}
//
//
//- (void)setCartID:(MMHID)cartID
//{
//    if (!self.account) {
//        return;
//    }
//    
//    if (self.isLoggingIn) {
//        return;
//    }
//    
//    if (self.account.cartID != cartID) {
//        self.account.cartID = cartID;
//        [self saveLastAccount:self.account];
//    }
//}
//
//
//@end


@implementation MMHAccountSession (IM)


//- (NSString *)chattingUserID
//{
//    if (!self.account) {
//        <#statements#>
//    }
//}


//- (BOOL)isReadyToChat
//{
//    if (!self.alreadyLoggedIn) {
//        return NO;
//    }
//    
//    NSLog(@" login info is: %@", [[EaseMob sharedInstance].chatManager loginInfo]);
//    if (![EaseMob sharedInstance].chatManager.isLoggedIn) {
//        return NO;
//    }
//    
//    NSString *userID = [[[EaseMob sharedInstance].chatManager loginInfo] stringForKey:@"username"];
//    if (userID.length == 0) {
//        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
//        return NO;
//    }
//    
//    if ([userID rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]].location != NSNotFound) {
//        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
//        return NO;
//    }
//    
//    return YES;
//}
//
//
//- (void)loginChattingAccountWithWaiterID:(NSString *)waiterID succeededHandler:(void (^)())succeededHandler failedHander:(void (^)(NSError *error))failedHandler
//{
//    if (self.isReadyToChat) {
//        // if chatting account already logged in, just add friend with waiter, never mind if the add-friend-request will succeed or not
//        if (waiterID.length != 0) {
//            NSString *userID = [[self class] chattingUserID];
//            if (userID.length != 0) {
//                [[MMHNetworkAdapter sharedAdapter] addFriendWithMyUserID:userID waiterUserID:waiterID from:self succeededHandler:nil failedHandler:nil];
//            }
//        }
//        succeededHandler();
//        return;
//    }
//
////    NSDictionary *savedUserInfo = [[self class] chattingUserInfo];
////    if (savedUserInfo.count == 0) {
//        NSString *generatedUserID = [[self class] generateChattingUserID];
//        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:generatedUserID
//                                                             password:generatedUserID
//                                                       withCompletion:^(NSString *username, NSString *password, EMError *error) {
//                                                           if (error) {
//                                                               if (error.errorCode == EMErrorServerDuplicatedAccount) {
//                                                                   [self loginChattingAccountWithUserName:username password:password waiterID:waiterID succeededHandler:succeededHandler failedHandler:failedHandler];
//                                                                   return;
//                                                               }
//                                                               if (failedHandler) {
//                                                                   NSError *e = [[NSError alloc] initWithDomain:@"EMError" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey: [error description]}];
//                                                                   failedHandler(e);
//                                                               }
//                                                               return;
//                                                           }
//                                                           [self loginChattingAccountWithUserName:username password:password waiterID:waiterID succeededHandler:succeededHandler failedHandler:failedHandler];
//                                                       } onQueue:nil];
////    }
////    else {
////        NSString *savedUserName = savedUserInfo[@"username"];
////        NSString *savedPassword = savedUserInfo[@"password"];
////        [self loginChattingAccountWithUserName:savedUserName
////                                      password:savedPassword
////                                      waiterID:waiterID
////                              succeededHandler:succeededHandler
////                                 failedHandler:failedHandler];
////    }
//}
//
//
//- (void)loginChattingAccountWithUserName:(NSString *)userName password:(NSString *)password waiterID:(NSString *)waiterID succeededHandler:(void (^)())succeededHandler failedHandler:(void (^)(NSError *error))failedHandler
//{
//    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName
//                                                        password:password
//                                                      completion:^(NSDictionary *loginInfo, EMError *error) {
//                                                          if (!error && loginInfo) {
//                                                              [[self class] setChattingUserInfo:loginInfo];
//                                                              [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
//                                                              if (waiterID.length != 0) {
//                                                                  [[MMHNetworkAdapter sharedAdapter] addFriendWithMyUserID:loginInfo[@"username"] waiterUserID:waiterID from:self succeededHandler:nil failedHandler:nil];
//                                                              }
//                                                              if (succeededHandler) {
//                                                                  succeededHandler();
//                                                              }
//                                                          }
//                                                          else {
//                                                              if (failedHandler) {
//                                                                  NSError *e = [[NSError alloc] initWithDomain:@"EMError" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey: [error description]}];
//                                                                  failedHandler(e);
//                                                              }
//                                                          }
//                                                      } onQueue:nil];
//}
//
//
//+ (NSString *)chattingUserID
//{
//    if ([MMHAccountSession currentSession].alreadyLoggedIn) {
//        return [MMHAccountSession currentSession].memberID;
//    }
//    return nil;
////    NSDictionary *chattingUserInfo = [self chattingUserInfo];
////    if (chattingUserInfo.count == 0) {
////        return nil;
////    }
////    
////    return chattingUserInfo[@"username"];
//}
//
//
//+ (NSDictionary *)chattingUserInfo
//{
//    return nil;
//    return [[NSUserDefaults standardUserDefaults] objectForKey:MMHAccountSessionChattingUserInfo];
//}
//
//
//+ (void)setChattingUserInfo:(NSDictionary *)chattingUserInfo {
//    if (chattingUserInfo == nil) {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:MMHAccountSessionChattingUserInfo];
//        return;
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:chattingUserInfo forKey:MMHAccountSessionChattingUserInfo];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//
//+ (NSString *)generateChattingUserID
//{
//    NSString *memberID = [[self currentSession] memberID];
//    if (memberID.length != 0) {
//        return memberID;
//    }
//    
//    return @"";
//
////    NSString *string = [UIDevice deviceID];
////    if ([string length] == 0) {
////        string = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
////    }
////
////    string = [string stringByAppendingFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
////    string = [string lowercaseString];
////    return string;
//}


@end

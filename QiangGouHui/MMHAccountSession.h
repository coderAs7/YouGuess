//
//  MMHAccountSession.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/9.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MMHAccount;


NS_ASSUME_NONNULL_BEGIN


@interface MMHAccountSession : NSObject

@property (nonatomic) BOOL isLoggingIn;

+ (MMHAccountSession *)currentSession;

+ (void)start;

- (void)accountDidLogin:(MMHAccount *)account;
- (BOOL)hasAnyAccountLoggedInOrLoggingIn;
- (BOOL)alreadyLoggedIn;

- (nullable NSString *)userId;
- (nullable NSString *)username;
- (nullable NSString *)token;
- (nullable NSString *)avatar;
- (nullable NSString *)nickname;

- (void)logoutWithCompletion:(void (^ __nullable)(BOOL succeeded))completion;

//- (void)updatePeronalInfoModel:(MMHPersonalInfoModel *)personalInfoModel;
//- (void)updateMemberInfoWithMemberCenterInfo:(MMHMemberCenterInfoModel *)memberCenterInfo;
//- (void)updatePersonInfoWithPerCenterInfo:(MMHPersonalCenterInfoModel *)personCenterInfo;

//- (BOOL)isFirstLogin;
//
//- (BOOL)isOpenPopularize;
//- (int)popularizeType;    //1：GB员工； 2：mamahao员工； 3：地推人员； -1：无效类型
//- (NSString *)promotionDomain;
//
//- (BOOL)isOpenCloudCenter;
//- (NSString *)cloudCenterLoginUrl;

@end


//@interface MMHAccountSession (Cart)
//
//@property (nonatomic) MMHID cartID;
//
//@end


@interface MMHAccountSession (IM)

//@property (nonatomic) NSString *chattingUserID;

//- (BOOL)isReadyToChat;
//- (void)loginChattingAccountWithWaiterID:(NSString * __nullable)waiterID succeededHandler:(void (^)())succeededHandler failedHander:(void (^)(NSError *error))failedHandler;
//
//+ (NSString *)chattingUserID;
//+ (NSDictionary *)chattingUserInfo;
//+ (void)setChattingUserInfo:(nullable NSDictionary *)chattingUserInfo;
@end


NS_ASSUME_NONNULL_END


//
//  MMHAccount.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/1.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHFetchModel.h"


//@class MMHAddressSingleModel;
//@class MMHSocialAccountInfo;


@interface MMHAccount : MMHFetchModel <NSCoding>

@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *expireTime;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *liveAddress;

//@property (nonatomic, copy) NSString *phoneNumber;
//@property (nonatomic, copy) NSString *password;

//@property (nonatomic, strong) MMHAddressSingleModel *defaultAddress;

//@property (nonatomic, copy) NSString *externalID;
//@property (nonatomic) MMHShareType externalType;

//@property (nonatomic) MMHID cartID;

//微推广
//@property (nonatomic) int openPromotionCenter;
//@property (nonatomic) int promoterType;
//@property (nonatomic, strong) NSString *promotionDomain;

//微分销
//@property (nonatomic) int openCloudCenter;
//@property (nonatomic, strong) NSString *cloudCenterLoginUrl;

//@property (nonatomic, copy) NSString *socialAccountAvatar;
//@property (nonatomic, copy) NSString *socialAccountNickname;

- (BOOL)shouldAutoLogin;

- (BOOL)isActivated;

//- (void)updateWithSocialAccountInfo:(MMHSocialAccountInfo *)accountInfo;
@end

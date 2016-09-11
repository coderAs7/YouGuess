//
//  QGHConversation.h
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/11.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMClient.h"

@interface QGHConversation : NSObject

@property (nonatomic, copy) NSString *conversationID;
@property (nonatomic, copy) NSString *conversationName;
@property (nonatomic, copy) NSString *conversationImgUrl;
@property (nonatomic, strong) UIImage *conversationImg;
@property (nonatomic, strong) EMMessage *message;

@end

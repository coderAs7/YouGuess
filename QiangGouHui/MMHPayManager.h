//
//  MMHPayManager.h
//  MamHao
//
//  Created by fishycx on 15/11/17.
//  Copyright © 2015年 Mamahao. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;


typedef void(^MMHPaySuccessHandler)();
typedef void(^MMHPayFailHandler)(NSString *error);


@interface MMHPayManager : NSObject


+ (instancetype)sharedInstance;

- (void)goToPayManager:(NSString *)orderNo payWay:(MMHPayWay)payWay invoker:(UIViewController *)controller successHandler:(MMHPaySuccessHandler)successHandler failHandler:(MMHPayFailHandler)failHandler;

@end

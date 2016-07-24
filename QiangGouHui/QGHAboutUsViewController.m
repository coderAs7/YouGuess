//
//  QGHAboutUsViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/23.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHAboutUsViewController.h"
#import "MMHNetworkAdapter+Personal.h"


@interface QGHAboutUsViewController ()

@end


@implementation QGHAboutUsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MMHNetworkAdapter sharedAdapter] fetchAboutUsFrom:self succeededHandler:^{
        //
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
}


@end

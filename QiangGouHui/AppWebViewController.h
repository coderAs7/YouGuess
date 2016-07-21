//
//  AppWebViewController.h
//  easydoctor
//
//  Created by stone on 15/11/12.
//  Copyright © 2015年 easygroup. All rights reserved.
//  web controller

#import "BaseViewController.h"

@interface AppWebViewController : BaseViewController

@property(nonatomic,copy) NSString *webUrl;
@property(nonatomic,copy) NSString *webTitle;
@property(nonatomic,copy) NSString *localHtml;
@property(nonatomic,copy) NSString *localHtmlString;

@end

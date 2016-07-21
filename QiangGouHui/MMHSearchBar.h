//
//  MMHSearchBar.h
//  MamHao
//
//  Created by fishycx on 15/5/19.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ NaviBtnAction)(UIButton *sender);

typedef void(^ TextFieldAction)(UITextField *sender);

typedef void(^ SearVcMoveToParentVcWhenNextVcPop)(void);
@interface MMHSearchBar : UIView

@property (nonatomic, copy)NaviBtnAction naviAction ;

//@property (nonatomic, strong)MMHClassificationViewController *parentClassficationController;

@property (nonatomic, copy)TextFieldAction textFieldAction;

@property (nonatomic, copy)SearVcMoveToParentVcWhenNextVcPop nextVCPop;

- (void)setTextFieldAction:(TextFieldAction)textFieldAction;
- (void)setNextVCPop:(SearVcMoveToParentVcWhenNextVcPop)nextVCPop;

@end


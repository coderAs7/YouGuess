//
//  MMHSearchBar.m
//  MamHao
//
//  Created by fishycx on 15/5/19.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHSearchBar.h"
#import "MMHSearchViewController.h"
//#import "MMHCategory.h"
#import "MMHSearchViewController.h"
@interface MMHSearchBar ()<UITextFieldDelegate>
@property (nonatomic, strong) MMHSearchViewController *searchVc;
@property (nonatomic, strong) UIView *searchBackView;
@property (nonatomic, strong) UITextField *seachTextField; //搜索TextField
@property (nonatomic, strong) UIButton *rightNaviButoon; // 搜索右边的按钮；
@property (nonatomic, strong) NSMutableArray *historySearchArray;
@end
@implementation MMHSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, kScreenWidth, 44);
    if (self = [super initWithFrame:frame]) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        backgroundView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        
        _searchBackView = backgroundView;
        
        //leftButton
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 40, 40);
        [leftButton setImage:[UIImage imageNamed:@"basc_nav_back"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(handleLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:leftButton];
        
        //rightButton
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightNaviButoon = rightButton;
        [self.rightNaviButoon setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.rightNaviButoon.titleLabel.font = MMHFontOfSize(14);
        rightButton.frame = CGRectMake(kScreenWidth - MMHFloat(54), 0, MMHFloat(54), 44);
        [rightButton setImage:[UIImage imageNamed:@"mmh_btn_scan"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(handleRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:rightButton];
        
        //textField
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(MMHFloat(40), 6, self.bounds.size.width -MMHFloat(94) , 32)];
        self.seachTextField.tag = 1234;
        self.seachTextField  = field;
        field.clearButtonMode =  UITextFieldViewModeWhileEditing;
        field.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_btn_add"]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 0, 34, 32);
        [button setImage:[UIImage imageNamed:@"mmh_icon_search"] forState:UIControlStateNormal];
        field.delegate = self;
        field.backgroundColor = [UIColor whiteColor];
        field.leftView = button;
        field.returnKeyType = UIReturnKeySearch;
        field.adjustsFontSizeToFitWidth = YES;
        field.leftViewMode = UITextFieldViewModeAlways;
        field.layer.cornerRadius = 10;
        field.placeholder = @"11";
        [backgroundView addSubview:field];
        [self addSubview:backgroundView];

    }
    return self;
}


- (NSMutableArray *)historySearchArray {
    if (!_historySearchArray) {
        self.historySearchArray = [NSMutableArray array];
    }
    return _historySearchArray;
}
- (MMHSearchViewController *)searchVc {
    if (!_searchVc) {
        self.searchVc = [[MMHSearchViewController alloc] init];
    }
    return _searchVc;
}

- (void)handleLeftBtn:(UIButton *)sender{
    
      self.naviAction(sender);
}

-(void)handleRightBtn:(UIButton *)sender{
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.seachTextField.frame = CGRectMake(MMHFloat(40), 6, self.bounds.size.width -MMHFloat(94) , 32);
        self.rightNaviButoon.frame = CGRectMake(kScreenWidth - MMHFloat(54), 0, MMHFloat(54), 44);
        [self.rightNaviButoon setTitle:nil forState:UIControlStateNormal];
        [self.rightNaviButoon setImage:[UIImage imageNamed:@"mmh_btn_scan"] forState:UIControlStateNormal];
    }];
    [self.seachTextField resignFirstResponder];
    [self.searchVc willMoveToParentViewController:nil];
    [self.searchVc.view removeFromSuperview];
    [self.searchVc removeFromParentViewController];
}

- (void)setTextFieldAction:(TextFieldAction)textFieldAction{
    
    [self.seachTextField resignFirstResponder];
}


- (void)setNextVCPop:(SearVcMoveToParentVcWhenNextVcPop)nextVCPop{
    [self.searchVc willMoveToParentViewController:nil];
    [self.searchVc.view removeFromSuperview];
    [self.searchVc removeFromParentViewController];
   
}
#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.rightNaviButoon setImage:nil forState:UIControlStateNormal];
        [self.rightNaviButoon setTitle:@"取消" forState:UIControlStateNormal];
        self.seachTextField.frame = CGRectMake(MMHFloat(10), 6, self.bounds.size.width - MMHFloat(64) , 32);
    }];
//    [self.parentClassficationController addChildViewController:self.searchVc];
//    [self.parentClassficationController.view addSubview:self.searchVc.view];
//    [self.searchVc didMoveToParentViewController:self.parentClassficationController];
    
  }

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (![textField.text isEqualToString:@""]) {
        [self.historySearchArray addObject:textField.text];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *doucumentsDirectory = paths.lastObject;
        NSString *filePath = [doucumentsDirectory stringByAppendingPathComponent:@"searchHistory"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:filePath];
            [array addObject:textField.text];
            [array writeToFile:filePath atomically:YES];
        }else{
            [self.historySearchArray writeToFile:filePath atomically:YES];
        }
    }
    [self.seachTextField resignFirstResponder];
    return YES;
}



@end

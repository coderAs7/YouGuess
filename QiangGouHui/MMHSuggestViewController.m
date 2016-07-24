//
//  MMHSuggestViewController.m
//  MamHao
//
//  Created by SmartMin on 15/6/2.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHSuggestViewController.h"
//#import "MMHNetworkAdapter+Center.h"
//#import "TWTTweetDetailInfoViewController.h"
#import "MMHNetworkAdapter+Personal.h"

#define WORD_LIMIT (140)

@interface MMHSuggestViewController()<UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UITextView *complaintTextView;              /**< 投诉textView*/
@property (nonatomic,strong)UITextView *adviceTextView;                 /**< 建议textView*/
@property (nonatomic,strong)UILabel *placeholder;                       /**< placeholder*/
@property (nonatomic,strong)UISegmentedControl *segment;                /**< segment*/
@property (nonatomic,strong)UIButton *sendButton;
@property (nonatomic,assign)BOOL isComplaint;                           /**< 判断是否是投诉*/
@property (nonatomic,strong)UILabel *textlimitLabel;                    // 控制文字长度的Label
@property (nonatomic,assign)BOOL isSend;
@property (nonatomic, assign) BOOL keyboardIsShow;
@end

@implementation MMHSuggestViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow) name:UIKeyboardDidShowNotification object:nil];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self pageSetting];
    [self createSegmentControl];
}

#pragma mark pageSetting
-(void)pageSetting{
    self.title = @"意见反馈";
}

#pragma mark - UISegmentedControl
-(void)createSegmentControl{
//    // segment
//    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"意见建议",@"我要投诉"]];
//    self.segment.frame = CGRectMake((kScreenBounds.size.width - MMHFloat(295))/2., MMHFloat(20), MMHFloat(295), MMHFloat(29));
//    self.segment.backgroundColor = [UIColor clearColor];
//    self.segment.selectedSegmentIndex = 0;
//    self.isComplaint = 0;
//    self.segment.tintColor = [UIColor colorWithCustomerName:@"粉"];
//    [self.segment addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:self.segment];
    
    // 投诉textView
    self.complaintTextView = [[UITextView alloc] init];
    self.complaintTextView.delegate = self;
    self.complaintTextView.textColor = [UIColor blackColor];
    self.complaintTextView.font = F4;
    self.complaintTextView.returnKeyType = UIReturnKeyDefault;
    self.complaintTextView.keyboardType = UIKeyboardTypeDefault;
    self.complaintTextView.backgroundColor = [UIColor whiteColor];
    self.complaintTextView.scrollEnabled = YES;
    self.complaintTextView.frame = CGRectMake(MMHFloat(16),  MMHFloat(20), kScreenBounds.size.width - 2 * MMHFloat(16), MMHFloat(128));
    [self.view addSubview:self.complaintTextView];
    
    // 建议textView
    self.adviceTextView = [[UITextView alloc] init];
    self.adviceTextView.delegate = self;
    self.adviceTextView.textColor = [UIColor blackColor];
    self.adviceTextView.layer.borderWidth = .5;
    self.adviceTextView.textAlignment = NSTextAlignmentJustified;
    self.adviceTextView.layer.borderColor = [UIColor colorWithHexString:@"dcdcdc"].CGColor;
    self.adviceTextView.font = F4;
    self.adviceTextView.returnKeyType = UIReturnKeyDefault;
    self.adviceTextView.keyboardType = UIKeyboardTypeDefault;
    self.adviceTextView.backgroundColor = [UIColor whiteColor];
    self.adviceTextView.scrollEnabled = YES;
    self.adviceTextView.frame = CGRectMake(MMHFloat(16),MMHFloat(20), kScreenWidth - 2 * MMHFloat(16), MMHFloat(128));
    [self.view addSubview:self.adviceTextView];
    
    // placeholder
    self.placeholder = [[UILabel alloc] init];
    self.placeholder.numberOfLines = 0;
    NSString *testStr = @"您的反馈是我们改进的动力，欢迎提出建议和意见，我们将尽快跟进提升用户体验";
    CGSize size = [testStr sizeWithFont:F3 constrainedToWidth:self.complaintTextView.bounds.size.width - 2 * MMHFloat(11) lineCount:10];
    self.placeholder.frame = CGRectMake(MMHFloat(7 + 16), self.complaintTextView.frame.origin.y + MMHFloat(10), self.complaintTextView.bounds.size.width - 2 * MMHFloat(11), size.height);
    self.placeholder.backgroundColor = [UIColor clearColor];
    self.placeholder.font = F3;
    self.placeholder.textColor = [UIColor colorWithRed:200/256.0 green:200/256.0 blue:200/256.0 alpha:1];
    [self.view addSubview:self.placeholder];
    
    // 确定发送按钮
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTitleColor:C21 forState:UIControlStateNormal];
    [self.sendButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[UIImage patternImageWithColor:C20] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[UIImage patternImageWithColor:C5] forState:UIControlStateDisabled];
    self.sendButton.layer.cornerRadius = 5.0f;
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.titleLabel.font = [UIFont systemFontOfCustomeSize:18];
    self.sendButton.backgroundColor = C20;
    self.sendButton.frame = CGRectMake(MMHFloat(16), CGRectGetMaxY(self.complaintTextView.frame) + MMHFloat(25), kScreenBounds.size.width - 2 * MMHFloat(16), MMHFloat(44));
    [self.view addSubview: self.sendButton];
    
    // 创建电话button
//    UILabel *contentLabel = [[UILabel alloc] init];
//    NSString *string = [NSString stringWithFormat:@"如遇到问题你可以联系客服%@",CustomerServicePhoneNumber];
//    NSRange range1 = [string rangeOfString:@"如遇到问题你可以"];
//    NSRange range2 = [string rangeOfString:[NSString stringWithFormat:@"联系客服%@",CustomerServicePhoneNumber]];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithCustomerName:@"白灰"] range:range1];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithCustomerName:@"蓝"] range:range2];
//    contentLabel.attributedText = str;
//    contentLabel.font=[UIFont fontWithCustomerSizeName:@"小提示"];
//    contentLabel.frame = CGRectMake(MMHFloat(16), CGRectGetMaxY(self.sendButton.frame) + MMHFloat(15), kScreenBounds.size.width - 2 * MMHFloat(16), 15);
//    contentLabel.textAlignment = NSTextAlignmentLeft;
//    contentLabel.numberOfLines=1;
//    contentLabel.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:contentLabel];

    // 创建按钮
//    UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [customerButton addTarget:self action:@selector(customerButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    customerButton.frame = contentLabel.frame;
//    customerButton.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:customerButton];
    
    // 创建文字长度
    self.textlimitLabel = [[UILabel alloc] init];
    self.textlimitLabel.frame = CGRectMake(kScreenWidth - 50 - MMHFloat(16), CGRectGetMaxY(self.adviceTextView.frame) + MMHFloat(3), 50, 20);
    self.textlimitLabel.text = [NSString stringWithFormat:@"%li/140",(long)0];
    self.textlimitLabel.textAlignment = NSTextAlignmentRight;
    self.textlimitLabel.textColor = [UIColor blackColor];
    self.textlimitLabel.font=[UIFont systemFontOfSize:13.];
    self.textlimitLabel.textColor = [UIColor lightGrayColor];
    self.textlimitLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.textlimitLabel];
    
    [self adjustWithButtonAndPlaceholder];

}




#pragma mark - actionClick
-(void)segmentSelected:(UISegmentedControl *)sender{
    NSInteger index = self.segment.selectedSegmentIndex;
    self.isComplaint = index;
    if (index == 0) {           // 意见建议
        [self.view bringSubviewToFront:self.adviceTextView];
    }else{
        [self.view bringSubviewToFront:self.complaintTextView];
    }
    [self.view bringSubviewToFront:self.placeholder];
    [self adjustWithButtonAndPlaceholder];
}

-(void)buttonClick{
    __weak typeof(self)weakSelf = self;
    [weakSelf.view showProcessingView];
    self.isSend = YES;
    [self.adviceTextView resignFirstResponder];
    
    if (self.keyboardIsShow == NO) {
        NSString *content = self.isComplaint == 0?self.adviceTextView.text:self.complaintTextView.text;
        [self sendRequestWithType:(self.isComplaint + 1) content:content];
    }
}

-(void)customerButtonClick{
//    __weak MMHSuggestViewController *weakViewController = self;
//    [MMHTool callCustomerServer:weakViewController.view phoneNumber:nil];
}

#pragma mark - UITextViewDelegate

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isContainsEmoji:text]) {
//        [textView showTips:@"暂不支持输入表情"];
//        return NO;
//    }else{
//        
//        NSInteger length = (long)[MMHTool calculateCharacterLengthForAres:textView.text];
//        if ( textView.text.length > WORD_LIMIT)
//        {
//            [self.view showTips:@"字数超出最大限制"];
//            textView.text = [textView.text substringToIndex:WORD_LIMIT];
//        }
//        [self adjustWithButtonAndPlaceholder];
//        return YES;
//    }
//}
-(void)textViewDidChange:(UITextView *)textView {
    
//    NSRange textRange = [textView selectedRange];
//    [textView setText:[self disable_emoji:[textView text]]];
//     [textView setSelectedRange:textRange];
    //该判断用于联想输入
 //  NSInteger length = (long)[MMHTool calculateCharacterLengthForAres:textView.text];
   NSInteger length = textView.text.length;
    if ( length > WORD_LIMIT)
    {
        [textView showTips:@"字数超出最大限制"];
        textView.text = [textView.text substringToIndex:WORD_LIMIT];
    }
    [self adjustWithButtonAndPlaceholder];

}




- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    UITextInputMode *inputMode = textView.textInputMode;
    if (inputMode == nil) {
        //当输入法为emoji时，inputMode为空
        [textView showTips:@"暂不支持输入表情"];
        return NO;
    }
    
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([string length] > WORD_LIMIT) {
        return NO;
    }
    
    if (range.location > 139) {
        return NO;
    } else {
        return YES;
    }
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if([text isEqualToString:@"\n"]) {
//        return YES;
//    }
//    NSString *toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    if(textView == self.complaintTextView) {
//        if([toBeString length] > WORD_LIMIT) {
//            [self.view showTips:@"字数超出最大限制"];
//            textView.text = [toBeString substringToIndex:WORD_LIMIT];
//            [self adjustWithButtonAndPlaceholder];
//            return NO;
//        }
//    } else if (textView == self.adviceTextView){
//        if ([toBeString length] > WORD_LIMIT){
//            [self.view showTips:@"字数超出最大限制"];
//            textView.text = [toBeString substringToIndex:WORD_LIMIT];
//            return NO;
//        }
//    }
//    return YES;
//}

#pragma mark 判断是否高亮
-(void)adjustWithButtonAndPlaceholder{
    if (self.isComplaint == 0){ // 建议
        if (self.adviceTextView.text.length == 0){
            self.placeholder.text = @"您的反馈是我们改进的动力，欢迎提出建议和意见，我们将尽快跟进提升用户体验";
            self.sendButton.enabled = NO;
        } else {
            self.placeholder.text = @"";
            self.sendButton.enabled = YES;
        }
        //self.textlimitLabel.text = [NSString stringWithFormat:@"%li/%d",(long)[MMHTool calculateCharacterLengthForAres:self.adviceTextView.text],WORD_LIMIT];
        self.textlimitLabel.text = [NSString stringWithFormat:@"%ld/%d", (long)self.adviceTextView.text.length, WORD_LIMIT];
    } else {                    // 投诉
        if (self.complaintTextView.text.length == 0){
            self.placeholder.text = @"请填写投诉";
            self.sendButton.enabled = NO;
        } else {
            self.placeholder.text = @"";
            self.sendButton.enabled = YES;
        }
        //self.textlimitLabel.text = [NSString stringWithFormat:@"%li/%d",(long)[MMHTool calculateCharacterLengthForAres:self.complaintTextView.text],WORD_LIMIT];
        self.textlimitLabel.text = [NSString stringWithFormat:@"%ld/%d",  (long)self.complaintTextView.text.length , WORD_LIMIT];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isComplaint == 0){
        if ([self.adviceTextView isFirstResponder]){
            [self.adviceTextView resignFirstResponder];

        }
    } else {
        if ([self.complaintTextView isFirstResponder]){
            [self.complaintTextView resignFirstResponder];
        }
    }
}


- (void)keyboardHide{
    self.keyboardIsShow = NO;
     NSString *content = self.isComplaint == 0?self.adviceTextView.text:self.complaintTextView.text;
    if (self.isSend) {
        [self sendRequestWithType:(self.isComplaint + 1) content:content];
    }
}

- (void)keyboardShow {
    self.keyboardIsShow = YES;
}

#pragma mark - sendRequest
-(void)sendRequestWithType:(NSInteger)type content:(NSString *)content{
    [self.adviceTextView resignFirstResponder];
    if (!self.adviceTextView.isFirstResponder) {
        [[MMHNetworkAdapter sharedAdapter] sendSuggestionFrom:self content:content succeededHandler:^{
            [self.view showTips:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failHandler:^(NSError *error) {
            [self.view showTipsWithError:error];
        }];
    }
}

- (void)dealloc{
   
}
#pragma mark-alertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end

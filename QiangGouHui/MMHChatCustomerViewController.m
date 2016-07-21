//
//  MMHChatCustomerViewController.m
//  MamHao
//
//  Created by fishycx on 15/5/23.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHChatCustomerViewController.h"
//#import "AbstractViewController+Chatting.h"


@interface MMHChatCustomerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MMHChatCustomerViewController


#pragma mark - getter method


- (UIView *)tipsView {
    if (!_tipsView) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.font = F3;
        tipsLabel.textColor = [UIColor colorWithHexString:@"d69200"];
        [tipsLabel setSingleLineText:@"温馨提示：春节期间 服务时间为每天"];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = F3;
        timeLabel.textColor = C5;
        [timeLabel setSingleLineText:@"10:00-18:00"];
        
        _tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), tipsLabel.height + 12)];
        _tipsView.backgroundColor = [UIColor colorWithHexString:@"fffde5"];
        [_tipsView addSubview:tipsLabel];
        [_tipsView addSubview:timeLabel];
        
        tipsLabel.x = 10;
        tipsLabel.centerY = _tipsView.height * 0.5;
        
        timeLabel.x = tipsLabel.right;
        timeLabel.centerY = _tipsView.height * 0.5;
    }

    return _tipsView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(MMHFloat(10), 0, self.view.bounds.size.width - MMHFloat(10)*2, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
//    [self.view addSubview:self.tipsView];
    [self.view addSubview:self.tableView];
    [self pageSetting];
    self.tableView.scrollEnabled = NO;
    // Do any additional setup after loading the view.
}
- (void)pageSetting{
    self.navigationController.navigationBarHidden = NO;
   self.title = @"联系客服";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.layer.borderWidth = .5;
        cell.layer.borderColor = [UIColor colorWithHexString:@"dcdcdc"].CGColor;
     }
    
    CGSize textSize = [@"在线客服" sizeWithCalcFont:MMHFontOfSize(20) constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    if (indexPath.section == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - MMHFloat(32)-MMHFloat(12)-textSize.width-MMHFloat(10)*2)/2, (MMHFloat(70)-MMHFloat(32))/2, MMHFloat(32), MMHFloat(32))];
        imageView.image = [UIImage imageNamed:@"free_chat_typing"];
        [cell.contentView addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+MMHFloat(12),(MMHFloat(70)-textSize.height)/2, textSize.width, textSize.height)];
        label.font = MMHFontOfSize(20);
        label.textColor = [UIColor colorWithHexString:@"888888"];
        label.text = @"在线客服";
        [cell addSubview:label];
        
    }else{
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - MMHFloat(32)-MMHFloat(12)-textSize.width-MMHFloat(10)*2)/2, (MMHFloat(70)-MMHFloat(32))/2, MMHFloat(32), MMHFloat(32))];
        imageView.image = [UIImage imageNamed:@"contact_icon_call"];
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+MMHFloat(12),0.0f, 0.0f, 0.0f)];
        label.font = MMHFontOfSize(20);
        label.textColor = [UIColor colorWithHexString:@"888888"];
        [label setSingleLineText:@"客服热线"];
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), 0.0f, 0.0f, 0.0f)];
        numberLabel.font = F5;
        numberLabel.textColor = [UIColor colorWithHexString:@"20c2c9"];
        [numberLabel setSingleLineText:@"4008813879"];
        [cell addSubview:numberLabel];
        [cell addSubview:label];
        
        label.top = MMHFloat(13.5f);
        [numberLabel moveToBottom:MMHFloat(70.0f - 13.50f)];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    
    
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 6, 20)];
    colorLabel.backgroundColor = C22;
    [view addSubview:colorLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colorLabel.frame)+MMHFloat(5), 20, 60, 15)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"人工服务";
    titleLabel.textColor = [UIColor colorWithHexString:@"383d40"];
    [view addSubview:titleLabel];
    
    UILabel *contenLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + MMHFloat(9),22, self.view.bounds.size.width - CGRectGetMaxX(titleLabel.frame)-MMHFloat(9), 13)];
    contenLabel.font = [UIFont systemFontOfSize:13];
    NSString *string = @"服务时间为每天8:30-23:30";
    NSMutableAttributedString *attributeString= [[NSMutableAttributedString alloc] initWithString:string];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"888888"]} range:NSMakeRange(0, string.length)];
    [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ff4d61"]} range:NSMakeRange(7, string.length-7)];
    contenLabel.attributedText = attributeString;
    [view addSubview:contenLabel];
    return view;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        [self startChattingWithContext:nil completion:nil];
//    }else{
//        __weak MMHChatCustomerViewController *weakViewController = self;
//        [MMHTool callCustomerServer:weakViewController.view phoneNumber:nil];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MMHFloat(70);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

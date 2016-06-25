//
//  QGHReceiptAddressViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/24.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHReceiptAddressViewController.h"
#import "QGHReceiptAddressCell.h"

static NSString *const QGHReceiptAddressCellIdentifier = @"QGHReceiptAddressCellIdentifier";


@interface QGHReceiptAddressViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation QGHReceiptAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地址";
    
    [self makeTableView];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"QGHReceiptAddressCell" bundle:nil] forCellReuseIdentifier:QGHReceiptAddressCellIdentifier];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
}


#pragma mark - UITalbeView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHReceiptAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHReceiptAddressCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

@end

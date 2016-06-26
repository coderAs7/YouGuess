//
//  QGHLogisticsDetailViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/26.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHLogisticsDetailViewController.h"
#import "QGHOrderDetailProductCell.h"
#import "QGHOrderLogisticsInfoCell.h"


static NSString *const QGHOrderDetailProductCellIdentifier = @"QGHOrderDetailProductCellIdentifier";
static NSString *const QGHOrderDetailLogisticsInfoCellIdentifier = @"QGHOrderDetailLogisticsInfoCellIdentifier";


@interface QGHLogisticsDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;

@end


@implementation QGHLogisticsDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流详情";
    
    [self makeTableView];
    [self makeBottomView];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mmh_screen_width(), mmh_screen_height() - 48 - 44) style:UITableViewStyleGrouped];
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"QGHOrderDetailProductCell" bundle:nil] forCellReuseIdentifier:QGHOrderDetailProductCellIdentifier];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHOrderLogisticsInfoCell" bundle:nil] forCellReuseIdentifier:QGHOrderDetailLogisticsInfoCellIdentifier];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(0);
        make.width.mas_equalTo(mmh_screen_width());
        make.bottom.mas_equalTo(48);
    }];
}


- (void)makeBottomView {
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bottomView addTopSeparatorLine];
    
//    _timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderDetails_icon_time"]];
//    _timeImageView.x = 15;
//    _timeImageView.centerY = 24;
//    [_bottomView addSubview:_timeImageView];
//    
//    _timeLabel = [[UILabel alloc] init];
//    _timeLabel.font = F3;
//    _timeLabel.textColor = C6;
//    _timeLabel.centerY = _timeImageView.centerY;
//    _timeLabel.x = _timeImageView.right + 10;
//    [_bottomView addSubview:_timeLabel];
    
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mmh_screen_width());
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(0);
    }];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 4;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QGHOrderDetailProductCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderDetailProductCellIdentifier forIndexPath:indexPath];
        return cell;
    } else {
        if (indexPath.row == 0) {
            static NSString *logisticsTitleIdentifier = @"logisticsTitle";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logisticsTitleIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logisticsTitleIdentifier];
                cell.textLabel.font = F4;
                cell.textLabel.textColor = C7;
            }
            cell.textLabel.text = @"物流公司：顺丰快递  物流单号：77565656565656";
            return cell;
        } else if (indexPath.row == 1) {
            static NSString *logisticsSubtitleIdentifier = @"logisticsSubtitle";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logisticsSubtitleIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logisticsSubtitleIdentifier];
                cell.textLabel.font = F6;
                cell.textLabel.textColor = C7;
            }
            cell.textLabel.text = @"物流详情";
            return cell;
        } else {
            QGHOrderLogisticsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHOrderDetailLogisticsInfoCellIdentifier forIndexPath:indexPath];
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    } else {
        if (indexPath.row == 0) {
            return 48;
        } else if (indexPath.row == 1) {
            return 48;
        } else {
            return UITableViewAutomaticDimension;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    } else {
        return 93;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}


@end

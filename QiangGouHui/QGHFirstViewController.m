//
//  QGHFirstViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/5.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHFirstViewController.h"
#import "QGHBannerCell.h"
#import "QGHRushPurchaseItemsCell.h"
#import "QGHGoodsTableViewCell.h"
#import "QGHGoodsHeaderView.h"
#import "QGHSegmentedControl.h"


static NSString *QGHBannerCellIdentifier = @"QGHBannerCellIdentifier";
static NSString *QGHPurchaseItemCellIdentifier = @"QGHPurchaseItemCellIdentifier";
static NSString *QGHGoodsCellIdentifier = @"QGHGoodsCellIdentifier";


@interface QGHFirstViewController ()<UITableViewDataSource, UITableViewDelegate, QGHSegmentedControlDelegate>

@property (nonatomic, strong) QGHSegmentedControl *segmented;
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation QGHFirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self makeTableView];
}


- (void)setNavigationBar {
    self.segmented = [[QGHSegmentedControl alloc] initWithTitleArr:@[@"抢购", @"预约", @"定制"]];
    self.segmented.delegate = self;
    self.navigationItem.titleView = self.segmented;
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"seach_ic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonAction)];
    self.navigationItem.rightBarButtonItem = searchItem;
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[QGHBannerCell class] forCellReuseIdentifier:QGHBannerCellIdentifier];
    [_tableView registerClass:[QGHRushPurchaseItemsCell class] forCellReuseIdentifier:QGHPurchaseItemCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:QGHGoodsCellIdentifier];
    [self.view addSubview:_tableView];
}


#pragma mark - UITalbeView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QGHBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHBannerCellIdentifier forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        QGHRushPurchaseItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHPurchaseItemCellIdentifier forIndexPath:indexPath];
        [cell testFunc];
        return cell;
    } else {
        QGHGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHGoodsCellIdentifier forIndexPath:indexPath];
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        static NSString *headerViewIdentifier = @"headerViewIdentifier";
        
        QGHGoodsHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewIdentifier];
        if (!view) {
            view = (QGHGoodsHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"QGHGoodsHeaderView" owner:self options:nil] lastObject];
        }
        
        return view;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    } else if (indexPath.section == 1) {
        return 270;
    } else {
        return 245;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.000001;
    } else if (section == 1) {
        return 50;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.000001;
    }
    return 10;
}


#pragma mark - QGHSegmentedControlDelegate


- (void)segmentedControlDidSelected:(NSInteger)index {
    //TODO
}

#pragma mark - Actions

- (void)searchButtonAction {
    //TODO
}


@end

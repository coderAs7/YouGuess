//
//  QGHProductSubClassViewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/9/15.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductSubClassViewController.h"
#import "MMHUnderlinedSegmentedControl.h"
#import "QGHLocationManager.h"
#import "QGHFirstPageGoodsList.h"
#import "QGHOrderList.h"
#import "QGHGoodsTableViewCell.h"
#import "QGHProductDetailVIewController.h"


static NSString *QGHGoodsCellIdentifier = @"QGHGoodsCellIdentifier";


@interface QGHProductSubClassViewController ()<HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, UITableViewDelegate, UITableViewDataSource, MMHTimelineDelegate>

@property (nonatomic, strong) MMHUnderlinedSegmentedControl *segmentList;
@property (nonatomic, strong) NSArray *segmentItemArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QGHFirstPageGoodsList *purchaseList;
@property (nonatomic, strong) QGHFirstPageGoodsList *appointList;
@property (nonatomic, strong) QGHFirstPageGoodsList *customList;
@property (nonatomic, strong) NSString *selectedGoodsType;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, assign) QGHBussType selectedFlag;

@end


@implementation QGHProductSubClassViewController


- (instancetype)initWithSelectedGoodsType:(NSString *)selectedGoodsType selectedArea:(NSString *)area {
    self = [super init];
    
    if (self) {
        _selectedGoodsType = selectedGoodsType;
        _selectedCity = area;
        _selectedFlag = QGHBussTypePurchase;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSegment];
    [self makeTableView];
    [self fetchGoodsList];
}


- (void)createSegment {
    self.segmentList = [[MMHUnderlinedSegmentedControl alloc] init];
    self.segmentList.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    self.segmentList.isNotScroll = NO;
    self.segmentList.isWordOfMouth = YES;
    self.segmentList.delegate = self;
    self.segmentList.dataSource = self;
    [self.segmentList setTitleColor:C7 forState:UIControlStateNormal];
    self.segmentList.font = F4;
    self.segmentList.selectionIndicatorColor = RGBCOLOR(254, 204, 47);
    self.segmentList.bottomTrimColor = [UIColor colorWithHexString:@"dcdcdc"];
    [self.segmentList setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.segmentItemArray = @[@"抢购", @"预约", @"定制"];
    [self.view addSubview:self.segmentList];
    
//    [self.segmentList mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(mmh_screen_width());
//        make.height.mas_equalTo(40);
//        make.top.mas_equalTo(0);
//    }];
    //    [self.segmentList setSelectedButtonIndex:self.transferItemSelected animated:YES];
    //    [self.segmentList.delegate selectionList:self.segmentList didSelectButtonWithIndex:self.transferItemSelected];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"QGHGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:QGHGoodsCellIdentifier];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mmh_screen_width());
        make.top.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
    }];
}


- (void)fetchGoodsList {
    //    if (![[MMHAccountSession currentSession] alreadyLoggedIn]) {
    //        return;
    //    }
    
    NSString *city = [[QGHLocationManager shareManager] currentCity];
    if (city.length == 0) {
        city = self.selectedCity;
    }
    
    _purchaseList = [[QGHFirstPageGoodsList alloc] initWithFlag:1 city:city goodstype:self.selectedGoodsType];
    _purchaseList.delegate = self;
    [_purchaseList refetch];
    
//    _appointList = [[QGHFirstPageGoodsList alloc] initWithFlag:2 city:city goodstype:self.selectedGoodsType];
//    _appointList.delegate = self;
//    [_appointList refetch];
    
//    _customList = [[QGHFirstPageGoodsList alloc] initWithFlag:3 city:city goodstype:self.selectedGoodsType];
//    _customList.delegate = self;
//    [_customList refetch];
}


- (void)loadMore {
    switch (self.selectedFlag) {
        case QGHBussTypePurchase:
            [_purchaseList fetchMore];
            break;
        case QGHBussTypeAppoint:
            [_appointList fetchMore];
            break;
        case QGHBussTypeCustom:
            [_customList fetchMore];
            break;
        default:
            break;
    }
}


- (void)refreshAction {
    switch (self.selectedFlag) {
        case QGHBussTypePurchase:
            [self.purchaseList refetch];
            break;
        case QGHBussTypeAppoint:
            [self.appointList refetch];
            break;
        case QGHBussTypeCustom:
            [self.customList refetch];
            break;
        default:
            break;
    }
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.selectedFlag) {
        case QGHBussTypePurchase:
            return [_purchaseList numberOfItems];
        case QGHBussTypeAppoint:
            return [_appointList numberOfItems];
        case QGHBussTypeCustom:
            return [_customList numberOfItems];
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([[self nameForSection:indexPath.section] isEqualToString:@"banner"]) {
//        QGHBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHBannerCellIdentifier forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.bannerArr = self.bannerArr;
//        cell.delegate = self;
//        return cell;
//    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"推荐"]) {
//        QGHRushPurchaseItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHPurchaseItemCellIdentifier forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setGoodList:self.purchaseList purchaseItemViewDelegate:self];
//        return cell;
//    } else {
        QGHGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHGoodsCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        QGHFirstPageGoodsModel *model = nil;
        switch (self.selectedFlag) {
            case QGHBussTypePurchase:
                model = [_purchaseList itemAtIndex:indexPath.row];
                break;
            case QGHBussTypeAppoint:
                model = [_appointList itemAtIndex:indexPath.row];
                break;
            case QGHBussTypeCustom:
                model = [_customList itemAtIndex:indexPath.row];
                break;
            default:
                break;
        }
        if (model) {
            [cell setGoodsModel:model];
        }
        return cell;
//    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHFirstPageGoodsList *list = nil;
    switch (self.selectedFlag) {
        case QGHBussTypePurchase:
            list = self.purchaseList;
            break;
        case QGHBussTypeAppoint:
            list = self.appointList;
            break;
        case QGHBussTypeCustom:
            list = self.customList;
            break;
        default:
            break;
    }
    
    if (list) {
        QGHFirstPageGoodsModel *product = [list itemAtIndex:indexPath.row];
        QGHProductDetailVIewController *productDetailVC = [[QGHProductDetailVIewController alloc] initWithBussType:product.type goodsId:product.goodsId];
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return mmh_screen_width() * 640 / 960 + 95;
}


//- (NSString *)nameForSection:(NSInteger)section {
//    switch (self.selectedFlag) {
//        case QGHBussTypePurchase:
//            return self.purchaseDataSource[section];
//        case QGHBussTypeAppoint:
//            return self.appointDataSource[section];
//        case QGHBussTypeCustom:
//            return self.customDataSource[section];
//        default:
//            return @"";
//    }
//}

#pragma mark - HTHorizontalSelectionListDataSource and Delegate


- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.segmentItemArray.count;
}


- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return [self.segmentItemArray objectAtIndex:index];
}


- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    self.selectedFlag = index + 1;
    [self.tableView reloadData];
}


#pragma mark - MMHTimeline delegate


- (void)timelineDataRefetched:(MMHTimeline *)timeline {
    [self.view hideProcessingView];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    if ([timeline hasMoreItems]) {
        [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    else {
        [self.tableView removeFooter];
    }
}


- (void)timelineMoreDataFetched:(MMHTimeline *)timeline {
    [self.view hideProcessingView];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    if (![timeline hasMoreItems]) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView removeFooter];
    }
}


- (void)timeline:(MMHTimeline *)timeline fetchingFailed:(NSError *)error {
    [self.view hideProcessingView];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.view showTipsWithError:error];
}


- (void)timeline:(MMHTimeline *)timeline itemsDeletedAtIndexes:(NSIndexSet *)indexes {
    [self.tableView reloadData];
}


@end

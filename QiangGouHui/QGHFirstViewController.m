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
#import "QGHProductDetailVIewController.h"
#import <CoreLocation/CoreLocation.h>
#import "QGHLocationManager.h"
#import "CityListViewController.h"
#import "MMHNetworkAdapter+FirstPage.h"
#import "QGHFirstPageGoodsList.h"
#import "MMHAccountSession.h"
#import <MJRefresh.h>
#import "MMHSearchViewController.h"
#import "MMHProductListViewController.h"
#import "QGHBanner.h"
#import "AdView.h"
#import "AppWebViewController.h"
#import "QGHRushPurchaseItemView.h"


static NSString *QGHBannerCellIdentifier = @"QGHBannerCellIdentifier";
static NSString *QGHPurchaseItemCellIdentifier = @"QGHPurchaseItemCellIdentifier";
static NSString *QGHGoodsCellIdentifier = @"QGHGoodsCellIdentifier";


@interface QGHFirstViewController ()<UITableViewDataSource, UITableViewDelegate, QGHSegmentedControlDelegate, MMHTimelineDelegate, QGHBannerCellDelegate, QGHRushPurchaseItemViewDelegate>

@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) QGHSegmentedControl *segmented;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, assign) QGHBussType selectedFlag;

@property (nonatomic, strong) NSArray<QGHBanner *> *bannerArr;
@property (nonatomic, strong) QGHFirstPageGoodsList *purchaseList;
@property (nonatomic, strong) QGHFirstPageGoodsList *appointList;
@property (nonatomic, strong) QGHFirstPageGoodsList *customList;

@property (nonatomic, strong) NSArray *purchaseDataSource;
@property (nonatomic, strong) NSArray *appointDataSource;
@property (nonatomic, strong) NSArray *customDataSource;

@end


@implementation QGHFirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedFlag = QGHBussTypePurchase;
    
    _purchaseDataSource = @[@"banner", @"推荐", @"商品"];
    _appointDataSource = @[@"banner", @"商品"];
    _customDataSource = @[@"banner", @"商品"];
    
    [self setNavigationBar];
    [self makeTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:MMHCurrentLocationNotification object:nil];
    
    [self fetchBanner];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[QGHAppearance themeColor]];
}


- (void)viewDidAppear:(BOOL)animated {
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的定位未打开，不能查看实体店，请打开定位！" message:@"方法：设置-隐私-定位服务-妈妈好-选择“始终”" delegate:nil cancelButtonTitle:@"我知道啦！" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}


- (void)setNavigationBar {
    self.segmented = [[QGHSegmentedControl alloc] initWithTitleArr:@[@"抢购", @"预约", @"定制"]];
    self.segmented.delegate = self;
    self.navigationItem.titleView = self.segmented;
    
//    NSString *city = [[QGHLocationManager shareManager] currentCity];
//    _locationButton = [[UIButton alloc] init];
//    [_locationButton setTitleColor:C21 forState:UIControlStateNormal];
//    _locationButton.titleLabel.font = F3;
//    if (city.length > 0) {
//        [_locationButton setTitle:city forState:UIControlStateNormal];
//    } else {
//        [_locationButton setTitle:@"定位" forState:UIControlStateNormal];
//    }
//    [_locationButton sizeToFit];
    
    NSString *city = [[QGHLocationManager shareManager] currentCity];
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.textColor = C21;
    _locationLabel.font = F3;
    if (city.length > 0) {
        _locationLabel.text = city;
    } else {
        _locationLabel.text = @"定位";
    }
    [_locationLabel sizeToFit];
    _locationLabel.width = 60;
    _locationLabel.userInteractionEnabled = YES;
    
    UIImage *triangle = [UIImage imageNamed:@"qgh_ic_dizhi"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:triangle];
    imageView.right = 60;
    imageView.bottom = _locationLabel.height;
    [_locationLabel addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapAction)];
    [_locationLabel addGestureRecognizer:tap];

    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc] initWithCustomView:_locationLabel];
    self.navigationItem.leftBarButtonItem = cityItem;
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"qgh_ic_sousuo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonAction)];
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


- (NSString *)nameForSection:(NSInteger)section {
    switch (self.selectedFlag) {
        case QGHBussTypePurchase:
            return self.purchaseDataSource[section];
        case QGHBussTypeAppoint:
            return self.appointDataSource[section];
        case QGHBussTypeCustom:
            return self.customDataSource[section];
        default:
            return @"";
    }
}


#pragma mark - network


- (void)fetchBanner {
    [[MMHNetworkAdapter sharedAdapter] fetchBannerFrom:self succeededHandler:^(NSArray<QGHBanner *> *bannerArr) {
        self.bannerArr = bannerArr;
        [self.tableView reloadData];
    } failedHandler:^(NSError *error) {
        //nothing to do
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
    
    _purchaseList = [[QGHFirstPageGoodsList alloc] initWithFlag:1 city:city];
    _purchaseList.delegate = self;
    [_purchaseList refetch];
    
    _appointList = [[QGHFirstPageGoodsList alloc] initWithFlag:2 city:city];
    _appointList.delegate = self;
    [_appointList refetch];
    
    _customList = [[QGHFirstPageGoodsList alloc] initWithFlag:3 city:city];
    _customList.delegate = self;
    [_customList refetch];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.selectedFlag == QGHBussTypePurchase) {
        return 3;
    } else {
        return 2;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self nameForSection:section] isEqualToString:@"banner"]) {
        return 1;
    } else if ([[self nameForSection:section] isEqualToString:@"推荐"]) {
        return 1;
    } else {
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
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self nameForSection:indexPath.section] isEqualToString:@"banner"]) {
        QGHBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHBannerCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bannerArr = self.bannerArr;
        cell.delegate = self;
        return cell;
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"推荐"]) {
        QGHRushPurchaseItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHPurchaseItemCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setGoodList:self.purchaseList purchaseItemViewDelegate:self];
        return cell;
    } else {
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
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self nameForSection:indexPath.section] isEqualToString:@"商品"]) {
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
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([[self nameForSection:section] isEqualToString:@"banner"]) {
        return nil;
    } else {
        static NSString *headerViewIdentifier = @"headerViewIdentifier";
        
        QGHGoodsHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewIdentifier];
        if (!view) {
            view = (QGHGoodsHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"QGHGoodsHeaderView" owner:self options:nil] lastObject];
        }
        
        switch (self.selectedFlag) {
            case QGHBussTypePurchase:
                if ([[self nameForSection:section] isEqualToString:@"推荐"]) {
                    view.label1.text = @"大家都在抢";
                    view.label2.text = @"下手晚就没了";
                    view.imageView.image = [UIImage imageNamed:@"qgh_img_qianggou"];
                } else {
                    view.label1.text = @"周边都在抢";
                    view.label2.text = @"发现身边的神奇";
                    view.imageView.image = [UIImage imageNamed:@"qgh_img_zhoubian"];
                }
                break;
            case QGHBussTypeAppoint:
                view.label1.text = @"预约有惊喜";
                view.label2.text = @"预约最新潮好货";
                view.imageView.image = [UIImage imageNamed:@"qgh_img_yuyue"];
                break;
            case QGHBussTypeCustom:
                view.label1.text = @"定制更个性";
                view.label2.text = @"打造你的专属";
                view.imageView.image = [UIImage imageNamed:@"qgh_img_dingzhi"];
                break;
            default:
                break;
        }
        
        return view;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self nameForSection:indexPath.section] isEqualToString:@"banner"]) {
        return 200;
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"推荐"]) {
        return 270;
    } else {
        return 245;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[self nameForSection:section] isEqualToString:@"banner"]) {
        return 0.000001;
    } else if ([[self nameForSection:section] isEqualToString:@"推荐"]) {
        return 50;
    } else {
        return 50;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([[self nameForSection:section] isEqualToString:@"商品"]) {
        return 0.000001;
    }
    return 10;
}


#pragma mark - QGHSegmentedControlDelegate


- (void)segmentedControlDidSelected:(NSInteger)index {
    self.selectedFlag = index + 1;
    [self.tableView reloadData];
}


#pragma mark - MMHTimeline delegate


- (void)timelineDataRefetched:(MMHTimeline *)timeline {
    [self.view hideProcessingView];
    [self.tableView reloadData];
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


#pragma mark - QGHBannerCellDelegate


- (void)bannerCellDidClick:(QGHBanner *)banner {
    QGHProductDetailVIewController *productDetailVC = [[QGHProductDetailVIewController alloc] initWithBussType:banner.type goodsId:banner.target_url];
    [self.navigationController pushViewController:productDetailVC animated:YES];
//    AppWebViewController *appWebViewVC = [[AppWebViewController alloc] init];
//    appWebViewVC.webUrl = @"http://121.14.38.35/Public/static/App/goodinfo148.html";
//    [self.navigationController pushViewController:appWebViewVC animated:YES];
}


#pragma mark - QGHRushPurchaseItemView


- (void)purchaseItemDidSelect:(QGHFirstPageGoodsModel *)goods {
    QGHProductDetailVIewController *productDetailVC = [[QGHProductDetailVIewController alloc] initWithBussType:goods.type goodsId:goods.goodsId];
    [self.navigationController pushViewController:productDetailVC animated:YES];
}


#pragma mark - Actions


- (void)locationTapAction {
    CityListViewController *cityListVC = [[CityListViewController alloc] init];
    cityListVC.selectedCity = self.selectedCity;
    cityListVC.selectCityBlock = ^(NSString *city) {
        [self.locationLabel setText:city];
        self.selectedCity = city;
        [self fetchGoodsList];
        [self.navigationController popToViewController:self animated:YES];
    };
    [self.navigationController pushViewController:cityListVC animated:YES];
}


- (void)searchButtonAction {
    MMHSearchViewController *searchVC = [[MMHSearchViewController alloc] init];
    searchVC.searchComplete = ^(MMHFilter *filter) {
        MMHProductListViewController *productListViewController = [[MMHProductListViewController alloc] initWithFilter:filter];
        [self.navigationController pushViewController:productListViewController animated:YES];
    };
    
    [self.navigationController pushViewController:searchVC animated:YES];
}


- (void)locationChange {
    NSString *city = [[QGHLocationManager shareManager] currentCity];
    if (city.length > 0) {
        self.selectedCity = city;
        [self.locationLabel setText:city];
        [self fetchGoodsList];
    }
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
    }}


@end

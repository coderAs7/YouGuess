//
//  MMHProductListViewController.m
//  MamHao
//
//  Created by SmartMin on 15/4/11.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHProductListViewController.h"
//#import "MMHProductsCollectionViewCell.h"
//#import "MMHProductsCollectionHeaderView.h"
//#import "MMHProductsCollectionFooterView.h"
#import "QGHProductListCell.h"
#import "MMHFilter.h"
#import "QGHProductList.h"
//#import "MMHProductList.h"
//#import "MMHWebViewController.h"
#import "MMHNetworkAdapter+Product.h"

//#import "MMHFilterTermSelectionViewController.h"
//#import "UIScrollView+MJRefresh.h"
//#import "MJRefreshFooter.h"
//#import "MMHCartItem.h"
#import "MMHSortView.h"
//#import "MMHProductDetailViewController.h"
//#import "MMHSwift.h"
#import "MMHTimeline.h"
//
#import "MMHSearchViewController.h"
//#import "MMHProductSpecSelectionViewController.h"
//#import "MMHNetworkAdapter+Cart.h"
//#import "MMHNetworkAdapter+Center.h"
#import "QGHProductDetailVIewController.h"
#import "QGHFirstPageGoodsModel.h"


static NSString * const QGHProductListCellIdentifier = @"QGHProductListCellIdentifier";
//static NSString * const MMHProductsCollectionFooterViewIdentifier = @"MMHProductsCollectionFooterViewIdentifier";
//static NSString * const MMHProductsCollectionCellIdentifier = @"MMHProductsCollectionCellIdentifier";


#define kProductList_Margin 11


@interface MMHProductListViewController ()<UITableViewDataSource, UITableViewDelegate, MMHFilterDelegate, MMHTimelineDelegate, UISearchBarDelegate, UITextFieldDelegate>

//@property (nonatomic, strong) UICollectionView *productsListCollectionView;
@property (nonatomic, strong) MMHFilter *filter;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, strong) UITextField *search;
@property (nonatomic, strong) MMHSortView *sortView;
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) MMHShoppingTipsModel *shoppingTipsModel;
@property (nonatomic, strong) QGHProductList *productList;
@property (nonatomic, strong) UIBarButtonItem *favouriteBarButtonItem;

@end


@implementation MMHProductListViewController


- (instancetype)initWithFilter:(MMHFilter *)filter {
    self = [self init];
    if (self) {
        self.filter = filter;
        filter.delegate = self;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    QGHProductList *productList = [[QGHProductList alloc] initWithFilter:self.filter];
    productList.delegate = self;
    self.productList = productList;
    [self pageSetting];
    [self createSortView];
    [self createTableView];
    
    [self.productList refetch];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    if (self.filter.module == MMHFilterModuleSearching && self.search) {
        self.title = @"";
        [self.navigationController.navigationBar addSubview:self.search];
    } else {
        if (self.title.length == 0) {
            self.title = @"商品列表";
        }
    }
}


- (void)dealloc {
    [self.tableView removeFooter];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.search removeFromSuperview];
    [self.tableView removeFooter];
}


#pragma mark - pagesetting


- (void)pageSetting {
    if (self.filter.module == MMHFilterModuleSearching) {
        CGRect frame = CGRectMake(40, 8, self.view.bounds.size.width - 40 - 15, 28);
        UITextField *field = [[UITextField alloc] initWithFrame:frame];
        self.search = field;
        field.stringTag = @"searchInProductList";
        field.backgroundColor = RGBCOLOR(247, 247, 247);
        field.borderStyle = UITextBorderStyleNone;
        field.clearButtonMode = UITextFieldViewModeAlways;
        field.delegate = self;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 0, 34, 32);
        [button setImage:[UIImage imageNamed:@"seach_ic"] forState:UIControlStateNormal];
        field.leftView = button;
        field.layer.cornerRadius = MMHFloat(5);
        field.adjustsFontSizeToFitWidth = YES;
        field.leftViewMode = UITextFieldViewModeAlways;
        //weakSelf.navigationItem.titleView = field;
        [self.navigationController.navigationBar addSubview:field];
        
        field.placeholder = @"搜索商品/门店";
        field.font = F4;
        field.text = self.filter.keyword;
    }
}


- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"QGHProductListCell" bundle:nil] forCellReuseIdentifier:QGHProductListCellIdentifier];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mmh_relative_float(42));
        make.right.and.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}


- (void)searchReloadView:(MMHFilter *)filter {
    if (self.filter.module != MMHFilterModuleSearching) {
        return;
    }
    
    self.filter = filter;
    self.filter.delegate = self;
    
    self.search.text = filter.keyword;
    
    [self createSortView];
    
//    MMHProductList *productList = [[MMHProductList alloc] initWithFilter:filter];
//    productList.delegate = self;
//    self.productList = productList;
//    [self.productList refetch];
    
    [self.tableView reloadData];
}


#pragma mark - <UITextFieldDelegate>

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    MMHSearchViewController *search = [[MMHSearchViewController alloc] initWithKeyword:textField.text];
    search.type = MMHSearchTypeProductList;
    __weak typeof(self) weakSelf = self;
    search.searchComplete = ^(MMHFilter *filter) {
        if (!weakSelf) return;
        
        [weakSelf searchReloadView:filter];
        
        QGHProductList *productList = [[QGHProductList alloc] initWithFilter:self.filter];
        productList.delegate = self;
        self.productList = productList;
        [productList refetch];
        
        [self.navigationController popViewControllerAnimated:NO];
    };
   
    [self.navigationController pushViewController:search animated:NO];
    return NO;
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.productList numberOfItems];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductListCellIdentifier forIndexPath:indexPath];
    cell.goods = [self.productList itemAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGHFirstPageGoodsModel *product = [self.productList itemAtIndex:indexPath.row];
    QGHProductDetailVIewController *productDetailVC = [[QGHProductDetailVIewController alloc] initWithBussType:product.type goodsId:product.goodsId];
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}


//#pragma mark - UICollectionViewDataSource
//
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    
//    return 1;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    
//    return [self.productList numberOfItems];
//}
//
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    MMHProductsCollectionViewCell *cell = (MMHProductsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MMHProductsCollectionCellIdentifier forIndexPath:indexPath];
//    
//    MMHSingleProductModel *singleProductModel = [self.productList itemAtIndex:indexPath.row];
//    cell.singleProduct = singleProductModel;
//    
//    return cell;
//}
//
//#pragma mark - UICollectionViewDelegateFlowLayout
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return [MMHProductsCollectionViewCell defaultSize];
////    CGFloat horizontalPadding = 29.0f;
////    CGFloat width = (mmh_screen_width() - horizontalPadding) * 0.5f;
////    CGFloat height = MMHFloatWithPadding(250.0f, horizontalPadding);
////    return CGSizeMake(width, height);
////    CGFloat itemHeight = MMHFloat(173) + MMHFloat(13) + [MMHTool contentofHeight:[UIFont fontWithCustomerSizeName:@"提示"]] * 2 + MMHFloat(12) + [MMHTool contentofHeight:[UIFont fontWithCustomerSizeName:@"副标题"]] + MMHFloat(8);
////    CGSize itemSize = CGSizeMake((self.view.bounds.size.width - MMHFloat(35)) / 2, itemHeight);
////    return itemSize;
//}
//
//
//#pragma mark - UICollectionViewDelegate
//
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    
//    return UIEdgeInsetsMake(9.0f, 10.0f, 0.0f, 9.0f);
////    return UIEdgeInsetsMake(5, MMHFloat(10), 5, MMHFloat(10));
//}
//
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    MMHSingleProductModel *singleProduct = [self.productList itemAtIndex:indexPath.row];
//    
//    MMHProductDetailViewController *productViewController = [[MMHProductDetailViewController alloc] initWithProduct:singleProduct];
//    productViewController.transfetSingleProductModel = singleProduct;
//    [self.navigationController pushViewController:productViewController animated:YES];
//}
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    CGSize size = CGSizeMake(mmh_screen_width(), self.headerViewHeight);
//    return size;
//}
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    CGSize size = CGSizeMake(mmh_screen_width(), 10.0f);
//    return size;
//}
//
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    MMHProductsCollectionHeaderView *headView;
//    
//    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MMHProductsCollectionHeaderViewIdentifier forIndexPath:indexPath];
//        headView.stringTag = @"headerView";
//        headView.shoppingTipsModel = self.shoppingTipsModel;                    // model
//        
//        headView.detailButtonClickBlock = ^(){                                  // push WebView Block
////            NSString *remoteURL = @"http://image.weixiao1688.com/U3203/17950.html";
////            MMHWebViewController *webViewController = [[MMHWebViewController alloc] initWithResourceName:@"" title:@"百度" isRemote:YES url:remoteURL];
////            [self.navigationController pushViewController:webViewController animated:YES];
//        };
//        
//        headView.headerViewHeightBlock = ^(CGFloat headerHeight){               // return height Block
//            self.headerViewHeight = headerHeight;
//            
//            [self.productsListCollectionView reloadData];
//        };
//        CGFloat y = self.headerViewHeight - self.sortView.bounds.size.height - self.productsListCollectionView.contentOffset.y;
//        self.sortView.top = MAX(0.0f, y);
//    }
//    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MMHProductsCollectionFooterViewIdentifier forIndexPath:indexPath];
//    }
//    return headView;
//}


- (void)loadMore {
    [self.view showProcessingView];
//    [self.productList fetchMore];
}


#pragma mark - MMHFilterDelegate


- (void)filterDidChange:(MMHFilter *)filter {
    [self.productList refetch];
}


- (void)timelineDataRefetched:(MMHTimeline *)timeline {
    [self.view hideProcessingView];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];

    if ([timeline numberOfItems] == 0) {
//        [self showBlankViewOfType:MMHBlankViewTypeProductList belowView:nil];
    }
    else {
//        [self hideBlankView];
//        if ([self.productList hasMoreItems]) {
//            [self.productsListCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//        }
//        else {
//            [self.productsListCollectionView removeFooter];
//        }
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

//
//#pragma mark - 获取店招等信息
//
//
//- (void)sendRequestWithGetShoppingTips {
//    [self.view showProcessingView];
//    __weak typeof(self)weakSelf = self;
//    [[MMHNetworkAdapter sharedAdapter] fetchProductListShoppingTipsWithCategory:self.filter.category from:self succeededHandler:^(MMHShoppingTipsModel *shoppingTipsModel) {
//        if (!weakSelf) {
//            return;
//        }
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf.shoppingTipsModel = shoppingTipsModel;
//        // 重新定义高度
//        CGFloat headerHeight = MMHFloat(42) + 60 + strongSelf.shoppingTipsModel.banner.count * MMHFloat(140);
//        strongSelf.headerViewHeight = headerHeight;
//        [strongSelf.view hideProcessingView];
//        [strongSelf.productList refetch];
//    } failedHandler:^(NSError *error) {
//        if (!weakSelf) {
//            return;
//        }
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf.productList refetch];
//    }];
//}


#pragma mark  - UIScrollViewDelegate


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.sortView.hidden = NO;
//    if (scrollView == self.tableView) {
//        CGPoint point = scrollView.contentOffset;
//        if ((self.headerViewHeight - self.sortView.bounds.size.height) <= point.y) {
////            self.sortView.alpha = (point.y) / (point.y + 20) * 0.9;
//        }
//        CGFloat y = self.headerViewHeight - self.sortView.bounds.size.height - point.y;
//        self.sortView.top = MAX(0.0f, y);
//    }
//}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}


- (void)createSortView {
    if (self.filter.module == MMHFilterModuleShop) {
        return;
    }
    
    if (self.sortView) {
        [self.sortView removeFromSuperview];
        self.sortView = nil;
    }
    self.sortView = [[MMHSortView alloc] initWithFrame:CGRectMake(0 , 0,self.view.bounds.size.width, mmh_relative_float(42)) filter:self.filter];
    [self.view addSubview:self.sortView];
}


@end

//
//  MMHSearchViewController.m
//  MamHao
//
//  Created by 余传兴 on 15/5/14.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHSearchViewController.h"
#import "MMHSearchCollectionViewCell.h"
#import "MMHSearchHistoryCollectionViewCell.h"
#import "MMHHeaderCollectionReusableView.h"
#import "MMHClassificationFooterView.h"
#import "MMHSearchBar.h"
//#import "MMHCategory.h"
#import "MMHFilter.h"
#import "MMHNetworkAdapter+Search.h"
//#import "MMHProductListViewController.h"
#import "QiangGouHui-Swift.h"


@interface MMHSearchViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIAlertViewDelegate, UISearchBarDelegate, MMHSearchingSuggestedKeywordsViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) MMHSearchingSuggestedKeywordsView *suggestedKeywordsView;

@property (nonatomic, copy) NSString *transferKeyword;
@end


@implementation MMHSearchViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWithKeyword:(NSString *)keyword {
    self = [super init];
    if (self) {
        self.transferKeyword = keyword;
    }
    return self;
}


#pragma mark - getter


- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray array];
    }
    return _datasource;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
    
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor redColor];
        [_collectionView registerClass:[MMHSearchCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[MMHSearchHistoryCollectionViewCell class] forCellWithReuseIdentifier:@"historyCell"];
        [_collectionView registerClass:[MMHHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[MMHClassificationFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        gestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        [_collectionView addGestureRecognizer:gestureRecognizer];
    }
    return _collectionView;
}


- (void)handleGestureRecognizer:(UISwipeGestureRecognizer *)gesture{
    [self.searchBar resignFirstResponder];
}


#pragma mark - View life cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    MMHSearchingSuggestedKeywordsView *suggestedKeywordsView = [[MMHSearchingSuggestedKeywordsView alloc] initWithFrame:self.view.bounds];
    suggestedKeywordsView.delegate = self;
    [self.view addSubview:suggestedKeywordsView];
    self.suggestedKeywordsView = suggestedKeywordsView;
    [self updateSuggestedKeywordsViewWithKeyword:self.transferKeyword];
    
//    __weak typeof(self)weakSelf = self;
//    [self leftBarButtonWithTitle:nil barNorImage:nil barHltImage:nil action:^{
//    
//    }];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = cancelBarButtonItem;
    
//    [self rightBarButtonWithTitle:@"取消" barNorImage:nil barHltImage:nil action:^{
//        switch (self.type) {
//            case MMHSearchTypeProductList:
//                [weakSelf.navigationController popViewControllerAnimated:NO];
//                break;
//            default:
//                [weakSelf popViewController];
//                break;
//        }
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}


- (void)fecthData {
    [self.datasource removeAllObjects];
    [[MMHNetworkAdapter sharedAdapter] fetchHotKeyListFrom:self succeededHandler:^(NSArray *keywords) {
        [self.datasource addObject:keywords];
        NSString *filePath = [self filePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:filePath];
            if (array.count) {
                if (self.datasource.count == 2) {
                    [self.datasource removeLastObject];
                }
                [self.datasource addObject:array];
            }
            
        }
        
        [self.collectionView reloadData];
    } failedHandler:^(NSError *error) {
        //
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fecthData];
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithStringTag:@"searchBar"];
    if (!search) {
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0f, 0.0f, mmh_screen_width()- 20-50.0f, 44)];
        self.searchBar = searchBar;
        searchBar.stringTag = @"searchBar";
        searchBar.placeholder = @"搜索商品/品牌";
        searchBar.delegate = self;
        searchBar.barTintColor = [QGHAppearance separatorColor];
        [searchBar setCustomBackgroundColor:RGBCOLOR(247, 247, 247)];
        searchBar.searchBarStyle = UISearchBarStyleDefault;
        searchBar.showsCancelButton = NO;
        [searchBar becomeFirstResponder];
        [searchBar layoutSubviews];
        [self.navigationController.navigationBar addSubview:searchBar];
    }
    if (self.transferKeyword) {
        self.searchBar.text = self.transferKeyword;
    }
}


- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectory = paths.lastObject;
    NSString *filePath = [doucumentsDirectory stringByAppendingPathComponent:@"searchHistory"];
    return filePath;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar removeFromSuperview];
}


- (void)updateSuggestedKeywordsViewWithKeyword:(NSString *)keyword {
    if (keyword.length == 0) {
        self.suggestedKeywordsView.hidden = YES;
    }
    else {
        self.suggestedKeywordsView.hidden = NO;
    }
    
    [self.suggestedKeywordsView updateWithKeyword:keyword];
}


#pragma mark - <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datasource.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.datasource[section] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *keyword = self.datasource[indexPath.section][indexPath.item];
    if (indexPath.section == 0) {
        MMHSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.title = keyword;
        return cell;
    }else {
        MMHSearchHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"historyCell" forIndexPath:indexPath];
        cell.keyWord = keyword;
        if (indexPath.item == [self.datasource[indexPath.section] count]) {
            cell.line.frame = CGRectZero;
        }
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
        NSString *identifier;
       if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        identifier = @"header";
        MMHHeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            view.title.text = @"热门";
            view.line.backgroundColor = [UIColor clearColor];
        }else{
          view.title.text = @"历史搜索";
        }
        return view;
    }else{
        identifier = @"footer";
        MMHClassificationFooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        [view setButtonAction:^(UIButton *sender) {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要清空历史吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alerView show];
        }];
        return view;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSString *filePath = [self filePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:filePath];
            [array removeAllObjects];
            [array writeToFile:filePath atomically:YES];
            [self.datasource removeLastObject];
            [self.collectionView reloadData];
        
        }
    }
}
#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.section < 0 || indexPath.section >= self.datasource.count) {
        return;
    }
    if (indexPath.item < 0 || indexPath.item >= ((NSArray *)self.datasource[indexPath.section]).count) {
        return;
    }
    
    NSString *keyWord = self.datasource[indexPath.section][indexPath.item];
    MMHFilter *filter = [[MMHFilter alloc] initWithKeyword:keyWord];
    self.searchComplete(filter);
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        NSString *str = self.datasource[indexPath.section][indexPath.item];
        CGSize size = [str sizeWithCalcFont:MMHFontOfSize(14) constrainedToSize:CGSizeMake(kScreenWidth, 30)];
        return CGSizeMake(size.width +MMHFloat(20), 30);
    }else {
        
        return CGSizeMake((self.view.bounds.size.width - MMHFloat(15)), 40);
    }
        
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == 0){
        return UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return UIEdgeInsetsMake(0, 15, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
   NSString *str = @"热门";
    CGSize size = [str sizeWithCalcFont:MMHFontOfSize(14) constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    return CGSizeMake(size.width, size.height+15+20);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
        return CGSizeZero;
    }else{
        return CGSizeMake(self.view.bounds.size.width, 40);
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    MMHSearchBar  *searchBar = (MMHSearchBar *)[self.navigationController.navigationBar viewWithStringTag:@"searchBar"];
//    [searchBar setTextFieldAction:^(UITextField *sender) {
//        
//    }];
    [self.searchBar resignFirstResponder];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}


#pragma mark - UISearBarDelegate


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    //
    switch (self.type) {
        case MMHSearchTypeProductList:
            [self.navigationController popViewControllerAnimated:NO];
            break;
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *text = searchBar.text;
    if (text.length == 0) {
        return;
    }
    [self searchWithKeyword:text];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateSuggestedKeywordsViewWithKeyword:searchText];
}

#pragma mark - Action
- (void)cancel {
    switch (self.type) {
        case MMHSearchTypeProductList:
            [self.navigationController popViewControllerAnimated:NO];
            break;
        default:
            [self.navigationController popViewControllerAnimated:NO];
            break;
    }
}

- (void)searchWithKeyword:(NSString *)keyword {
    NSString *filePath = [self filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:filePath];
        if (![array containsObject:keyword]) {
            [array insertObject:keyword atIndex:0];
            [array writeToFile:filePath atomically:YES];
        }
        else {
            [array moveObject:keyword toIndex:0];
        }
    }
    else {
        NSMutableArray *array = [NSMutableArray array];
        [array insertObject:keyword atIndex:0];
        [array writeToFile:filePath atomically:YES];
    }
    
    MMHFilter *filter = [[MMHFilter alloc] initWithKeyword:keyword];
    self.searchComplete(filter);
}


#pragma mark - keyboard notifications


- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
//    CGRect newTextViewFrame = self.suggestedKeywordsView.frame;
//    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.intValue];
    
    [self.suggestedKeywordsView setMaxY:self.view.bounds.size.height - keyboardRect.size.height];
    
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration.doubleValue];
    [UIView setAnimationCurve:curve.intValue];
    
    [self.suggestedKeywordsView setMaxY:self.view.bounds.size.height - keyboardRect.size.height];
    
    [UIView commitAnimations];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification {
//    NSDictionary* userInfo = [notification userInfo];
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
//    
//    CGFloat keyboardTop = keyboardRect.origin.y;
//    
//    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:duration.doubleValue];
//    [UIView setAnimationCurve:curve.intValue];
//    
//    [self.suggestedKeywordsView setMaxY:keyboardTop];
//    
//    [UIView commitAnimations];
}


#pragma mark - MMHSearchingSuggestedKeywordsViewDelegate


- (void)searchingSuggestedKeywordsView:(MMHSearchingSuggestedKeywordsView *)searchingSuggestedKeywordsView didSelectKeyword:(NSString *)keyword {
    self.suggestedKeywordsView.hidden = YES;
    [self searchWithKeyword:keyword];
}


@end

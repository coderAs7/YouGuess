//
//  MMHProductSpecSelectionViewController.m
//  MamHao
//
//  Created by Louis Zhu on 15/4/16.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHProductSpecSelectionViewController.h"
//#import "MMHProductDetailModel.h"
#import "UICollectionViewLeftAlignedLayout.h"
//#import "MMHFilterTermSelectionAgeGroupCell.h"
#import "QiangGouHui-Swift.h"
#import "QGHAppearance.h"
#import "QGHTabBarController.h"
#import "UIImageView+WebCache.h"
#import "QGHProductDetailModel.h"


NSString * const MMHProductSpecSelectionCellIdentifier = @"MMHProductSpecSelectionCellIdentifier";
NSString * const MMHProductSpecSelectionHeaderIdentifier = @"MMHProductSpecSelectionHeaderIdentifier";
//NSString * const MMHFilterTermSelectionDecorationViewIdentifier = @"MMHFilterTermSelectionDecorationViewIdentifier";


@interface MMHProductSpecSelectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StepperDelegate>

//@property (nonatomic, strong) ProductSpecFilter *specFilter;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MMHImageView *imageView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *selectedSpecsLabel;
@property (nonatomic, strong) UIView *confirmView;
@property (nonatomic, strong) Stepper *quantityStepper;
@property (nonatomic, strong) UILabel *quantityTipsLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, copy) void (^specSelectedHandler)(NSArray *selectedSpec);
@property (nonatomic, strong) UIButton *closeButton;
//@property (nonatomic, strong) id<MMHProductDetailProtocol> productDetail;
@property (nonatomic, strong) QGHProductDetailModel *productDetail;
@property (nonatomic, assign) BOOL isHideCount;

@end


@implementation MMHProductSpecSelectionViewController


- (CGSize)sizeWhileFloating
{
//    UIView *view = self.view;
    CGFloat collectionViewHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    CGFloat confirmViewHeight = 120;
    if (self.isHideCount) {
        confirmViewHeight = 50;
    }
    CGFloat totalHeight = 88.0f + collectionViewHeight + confirmViewHeight;
    CGFloat height = MIN(totalHeight, [[UIScreen mainScreen] applicationFrame].size.height * 0.75f);
    return CGSizeMake(mmh_screen_width(), height);
//    if ([self.specFilter hasAnySpecs]) {
//        return CGSizeMake(mmh_screen_width(), 420.0f);
//    }
//    return CGSizeMake(mmh_screen_width(), 220.0f);
}


//- (instancetype)initWithProductDetail:(id <MMHProductDetailProtocol>)productDetail isHideCount:(BOOL)isHideCount specSelectedHander:(void (^)(NSArray *selectedSpec))specSelectedHandler
//{
//    self = [self init];
//    if (self) {
//        self.productDetail = productDetail;
//        self.specFilter = productDetail.specFilter;
//        self.specSelectedHandler = specSelectedHandler;
//        self.isHideCount = isHideCount;
//    }
//    return self;
//}
- (instancetype)initWithProductDetail:(QGHProductDetailModel *)productDetail {
    self = [super init];
    
    if (self) {
        _productDetail = productDetail;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
//    if ([self.specFilter hasAnySpecs]) {
//        contentView.height = 420.0f;
//    }
//    else {
//        contentView.height = 220.0f;
//    }
//    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    self.contentView = contentView;

    UIView *imageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, -20.0f, 100.0f, 100.0f)];
    imageBackgroundView.backgroundColor = [UIColor whiteColor];
    imageBackgroundView.layer.cornerRadius = 5.0f;
    imageBackgroundView.layer.borderWidth = mmh_pixel();
    imageBackgroundView.layer.borderColor = [C2 CGColor];
    [self.contentView addSubview:imageBackgroundView];

    MMHImageView *imageView = [[MMHImageView alloc] initWithFrame:imageBackgroundView.bounds];
    [imageView setSize:CGSizeMake(90.0f, 90.0f)];
//    imageView.layer.borderColor = [[UIColor colorWithHexString:@"ebebeb"] CGColor];
//    imageView.layer.borderWidth = 1.0f;
    [imageBackgroundView addSubview:imageView];
    self.imageView = imageView;
    [imageView moveToCenterOfSuperview];
    
    UIImage *closeImage = [UIImage imageNamed:@"pro_btn_close"];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, closeImage.size.width, closeImage.size.height)];
    [closeButton moveToRight:CGRectGetMaxX(self.contentView.bounds) - 10.0f];
    closeButton.centerY = 44.0f;
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeButton];
    self.closeButton = closeButton;

    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 18.0f, 0.0f, 0.0f)];
//    [priceLabel setMaxX:self.closeButton.left];
    [priceLabel setMaxX:mmh_screen_width() - 36.0f];
    priceLabel.textColor = C21;
    priceLabel.font = F13;
//    [priceLabel setSingleLineText:@"￥29999.88" constrainedToWidth:CGFLOAT_MAX];
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;

    UILabel *selectedSpecsLabel = [[UILabel alloc] init];
    selectedSpecsLabel.left = self.priceLabel.left;
    selectedSpecsLabel.width = self.priceLabel.width;
//    [selectedSpecsLabel attachToBottomSideOfView:self.priceLabel byDistance:7.0f];
    selectedSpecsLabel.top = 53.0f;
    selectedSpecsLabel.font = F4;
    selectedSpecsLabel.textColor = C4;
    [self.contentView addSubview:selectedSpecsLabel];
    self.selectedSpecsLabel = selectedSpecsLabel;
    
    if (self.productDetail.categorylist.count > 0) {
        UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 88.0f - mmh_pixel(), mmh_screen_width() - 20.0f, mmh_pixel())];
        separatorLine.backgroundColor = [QGHAppearance separatorColor];
        [self.contentView addSubview:separatorLine];
    }

    UICollectionViewLeftAlignedLayout * layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(0.0f, 35.0f);
    layout.sectionInset = UIEdgeInsetsMake(15.0f, 10.0f, 15.0f, 10.0f);
    layout.minimumLineSpacing = 15.0f;
//    [layout registerClass:[FilterTermSelectionDecorationView class] forDecorationViewOfKind:MMHFilterTermSelectionDecorationViewIdentifier];
    
    CGFloat confirmViewHeight = 120;
    if (self.isHideCount) {
        confirmViewHeight = 50;
    }
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 88.0f, self.contentView.bounds.size.width, self.contentView.bounds.size.height - 88.0f - confirmViewHeight)
                                                          collectionViewLayout:layout];
//    collectionView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 90.0f, 0.0f);
//    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.allowsMultipleSelection = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.alwaysBounceVertical = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
//    [collectionView registerClass:[MMHFilterTermSelectionBrandCell class] forCellWithReuseIdentifier:MMHFilterTermSelectionBrandCellIdentifier];
    [collectionView registerClass:[ProductSpecSelectionCell class] forCellWithReuseIdentifier:MMHProductSpecSelectionCellIdentifier];
    [collectionView registerClass:[ProductSpecSelectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MMHProductSpecSelectionHeaderIdentifier];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;

    UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.contentView.bounds.size.width, confirmViewHeight)];
//    confirmView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [confirmView moveToBottom:CGRectGetMaxY(self.contentView.bounds)];
    confirmView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:confirmView];
    self.confirmView = confirmView;

    if (!self.isHideCount) {
        CGRect stepperFrame = CGRectMake(0.0f, 15.0f, 134.0f, 40.0f);
        Stepper *quantityStepper = [[Stepper alloc] initWithFrame:stepperFrame
                                                     minimumValue:1
                                                     maximumValue:NSIntegerMax
                                                            value:1];
        quantityStepper.right = CGRectGetMaxX(self.confirmView.bounds) - 10.0f;
        //    quantityStepper.bottom = CGRectGetMaxY(self.confirmView.bounds) - 85.0f;
        //    [quantityStepper addTarget:self action:@selector(quantityStepperStepped:) forControlEvents:UIControlEventValueChanged];
        quantityStepper.delegate = self;
        [self.confirmView addSubview:quantityStepper];
        self.quantityStepper = quantityStepper;
        
        UILabel *quantityTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 100.0f, 0.0f)];
        quantityTipsLabel.font = F6;
        quantityTipsLabel.textColor = C6;
        [quantityTipsLabel setText:@"购买数量" constrainedToLineCount:0];
        quantityTipsLabel.centerY = self.quantityStepper.centerY;
        [self.confirmView addSubview:quantityTipsLabel];
        self.quantityTipsLabel = quantityTipsLabel;
    }
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.confirmView.bounds.size.width, 50.0f)];
    confirmButton.bottom = CGRectGetMaxY(self.confirmView.bounds);
    [confirmButton setBackgroundImage:[UIImage patternImageWithColor:C20] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage patternImageWithColor:[QGHAppearance separatorColor]] forState:UIControlStateDisabled];
//    confirmButton.backgroundColor = [MMHAppearance pinkColor];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = F8;
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmView addSubview:confirmButton];
    self.confirmButton = confirmButton;
    
//    if ([self.specFilter hasAnySpecs]) {
        [self.confirmView addTopSeparatorLineWithPadding:10.0f];
//    }

//    [self.specFilter selectDefaultIndexes];
    [self updateViews];
    
    self.contentView.height = 88 + self.collectionView.collectionViewLayout.collectionViewContentSize.height + 120;
    [self.confirmView setBottom:self.contentView.height];
}


- (void)updateViews
{
//    NSString *priceString = [NSString stringWithFormat:@"￥ %.2f", self.productDetail.price];
//    [self.priceLabel setText:priceString constrainedToLineCount:1];
//
    NSArray *selectedSpecNames = [self.productDetail.categoryDict allKeys];
    if ([selectedSpecNames count] == 0) {
        self.selectedSpecsLabel.text = @"";
//        self.closeButton.hidden = YES;
    }
    else {
        NSArray *quotedSpecNames = [selectedSpecNames transformedArrayUsingHandler:^id(id originalObject, NSUInteger index) {
            return [NSString stringWithFormat:@"“%@”", originalObject];
        }];
        NSString *selectedSpecNamesString = [quotedSpecNames componentsJoinedByString:@" "];
        [self.selectedSpecsLabel setText:selectedSpecNamesString constrainedToLineCount:2];
//        self.closeButton.hidden = NO;
    }
    
//    [self.selectedSpecsLabel attachToBottomSideOfView:self.priceLabel byDistance:7.0f];
    [@[self.priceLabel, self.selectedSpecsLabel] setCenterY:44.0f];
    
    [self tryToUpdateSpecParameter];
}


- (void)close:(UIButton *)button
{
    [self.settledViewController dismissFloatingViewControllerAnimated:YES completion:^{
    }];
}


- (void)confirm:(UIButton *)confirmButton
{
    confirmButton.enabled = NO;
    if (self.shouldShowAddingToCartAnimation) {
        [self addAnimationWithView];
    }
    else {
            __weak __typeof(self) weakSelf = self;
            [self.settledViewController dismissFloatingViewControllerAnimated:YES completion:^{
                if (weakSelf.specSelectedHandler) {
//                    weakSelf.specSelectedHandler(weakSelf.specFilter.selectedSpecs);
                }
            }];
    }
}

#pragma mark ares 
-(void)confirmationManager{
    //    NSString *unselectedSpecName = [self.specFilter unselectedSpecName];
    //    if (unselectedSpecName) {
    //        [self.contentView showTips:[NSString stringWithFormat:@"请选择%@", unselectedSpecName]];
    //        return;
    //    }
        __weak __typeof(self) weakSelf = self;
        [self.settledViewController dismissFloatingViewControllerAnimated:YES completion:^{
            if (weakSelf.specSelectedHandler) {
//                weakSelf.specSelectedHandler(weakSelf.specFilter.selectedSpecs);
            }
        }];
}


#pragma mark - StepperDelegate


- (BOOL)stepper:(Stepper * __nonnull)stepper shouldChangeValueFrom:(NSInteger)currentValue to:(NSInteger)newValue
{
//    if ([self.specFilter isQuantityExceedsLimit:newValue]) {
//        [self.view showTips:[NSString stringWithFormat:@"最多只能购买%ld件哦~", (long)currentValue]];
//        return NO;
//    }
//    else {
//        self.specFilter.quantity = newValue;
//        return YES;
//    }
    self.productDetail.skuSelectModel.count = newValue;
    
    return YES;
}


- (void)quantityStepperStepped:(Stepper *)stepper
{
    self.productDetail.skuSelectModel.count = stepper.value;
}


#pragma mark - UICollectionView data source and delegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.productDetail.categoryDict.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *keys = self.productDetail.categoryDict.allKeys;
    NSArray *categoryArr = [self.productDetail.categoryDict objectForKey:[keys objectAtIndex:section]];
    return categoryArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = self.productDetail.categoryDict.allKeys;
    NSArray *categoryArr = [self.productDetail.categoryDict objectForKey:[keys objectAtIndex:indexPath.section]];
    NSString *name = ((QGHSKUCategory *)categoryArr[indexPath.row]).value;
    
    ProductSpecSelectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MMHProductSpecSelectionCellIdentifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 3.0f;
    cell.title = name;
    
//    if (![self.specFilter selectabilityForOptionAtIndex:indexPath.row forSpecAtSection:indexPath.section]) {
//        cell.enabled = NO;
//    }
//    else {
//        cell.enabled = YES;
//        
//        if (indexPath.row == [self.specFilter selectedOptionIndexOfSpecAtIndex:indexPath.section]) {
//            cell.selected = YES;
//            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//        }
//        else {
//            cell.selected = NO;
//            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//        }
//    }
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return nil;
    }

    ProductSpecSelectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                   withReuseIdentifier:MMHProductSpecSelectionHeaderIdentifier
                                                                                          forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.shouldShowTopSeparatorLine = NO;
    }
    else {
        headerView.shouldShowTopSeparatorLine = YES;
    }
    NSArray *keys = self.productDetail.categoryDict.allKeys;
    NSString *title = [keys objectAtIndex:indexPath.section];
    [headerView.titleLabel setSingleLineText:title keepingHeight:YES];
    return headerView;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = self.productDetail.categoryDict.allKeys;
    NSArray *categoryArr = [self.productDetail.categoryDict objectForKey:[keys objectAtIndex:indexPath.section]];
    
    NSString *nameOfOption = ((QGHSKUCategory *)[categoryArr objectAtIndex:indexPath.row]).name;
    
    CGSize size = [ProductSpecSelectionCell sizeWithString:nameOfOption];
    return size;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    BOOL selectability = [self.specFilter selectabilityForOptionAtIndex:indexPath.row forSpecAtSection:indexPath.section];
//    if (selectability) {
//        return YES;
//    }
//    
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (![self.specFilter selectabilityForOptionAtIndex:indexPath.row forSpecAtSection:indexPath.section]) {
//        [self.contentView showTips:@"没有库存"];
//        return;
//    }
//    
//    NSInteger selectedRow = [self.specFilter selectedOptionIndexOfSpecAtIndex:indexPath.section];
//    if (selectedRow == indexPath.row) {
//        return;
//    }
//    
//    [self.specFilter setSelectedOptionIndex:indexPath.row ofSpecAtIndex:indexPath.section];
    [collectionView reloadData];
    [self updateViews];
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (![self.specFilter selectabilityForOptionAtIndex:indexPath.row forSpecAtSection:indexPath.section]) {
//        return NO;
//    }
    
//    NSInteger selectedRow = [self.specFilter selectedOptionIndexOfSpecAtIndex:indexPath.section];
//    if (selectedRow == indexPath.row) {
//        return NO;
//    }
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [self.specFilter setSelectedOptionIndex:-1 ofSpecAtIndex:indexPath.section];
    [collectionView reloadData];
    [self updateViews];
}


- (void)tryToUpdateSpecParameter
{
    self.confirmButton.enabled = NO;
    if (![self.productDetail isAllSpecSelected]) {
        self.priceLabel.text = @"";
        return;
    }
    
//    if (![self.specFilter isCurrentSelectionAvailableForSale]) {
        self.priceLabel.text = @"暂无供应";
        return;
//    }
//    else {
        self.priceLabel.text = @"";
//    }
    
//    if (self.productDetail.defaultImage && self.productDetail.defaultPrice > 0) {
//        [self.imageView updateViewWithImageAtURL:self.productDetail.defaultImage];
//        [self.priceLabel setText:[NSString stringWithPrice:self.productDetail.defaultPrice] constrainedToLineCount:1];
//        self.confirmButton.enabled = YES;
//        return;
//    }
    
//    ProductSpecParameter *selectedSpecParameter = self.specFilter.selectedSpecParameter;
//    if (selectedSpecParameter != nil) {
//        [self updateSpecParameterViewsWithSpecParameter:selectedSpecParameter];
//        return;
//    }
//    
//    [self.contentView showProcessingViewWithYOffset:0.0f];
//    __weak typeof(self) weakSelf = self;
//    [self.specFilter fetchParameterForCurrentSelectionWithCompletion:^(BOOL succeeded, ProductSpecParameter * __nullable specParameter) {
//        [weakSelf.contentView hideProcessingView];
//        if (!succeeded) {
//            [weakSelf.contentView showTips:@"无法获取价格信息, 请检查网络"];
//        }
//        [weakSelf updateSpecParameterViewsWithSpecParameter:specParameter];
//    }];
}


//- (void)updateSpecParameterViewsWithSpecParameter:(ProductSpecParameter *)specParameter
//{
//    if (specParameter == nil) {
//        [self.imageView sd_cancelCurrentImageLoad];
//        [self.imageView updateViewWithImage:nil];
//        [self.priceLabel setText:@"未知价格" constrainedToLineCount:1];
//        self.confirmButton.enabled = NO;
//    }
//    else {
//        [self.imageView updateViewWithImageAtURL:specParameter.imageURLString];
//        if (self.productDetail.isBeanProduct) {
//            NSString *priceString = [NSString beanPriceStringWithPrice:self.specFilter.selectedSpecParameter.price beanPrice:self.specFilter.selectedSpecParameter.beanPrice];
//            [self.priceLabel setText:priceString constrainedToLineCount:1];
//        }
//        else {
//            [self.priceLabel setText:[NSString stringWithPrice:specParameter.price] constrainedToLineCount:1];
//        }
//        self.confirmButton.enabled = YES;
//    }
//}


#pragma mark - Ares addShoppingCartAnimation


- (void)addAnimationWithView {
    UIImageView *productImageView = [[UIImageView alloc] init];
    productImageView.image = self.imageView.image;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [self.imageView convertRect:self.imageView.bounds toView:window];
    productImageView.frame = rect;
    [self.view.window addSubview:productImageView];

    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         [productImageView setFrame:CGRectMake(mmh_screen_width() - 20.0f, 30.0f, productImageView.width * 0.1f, productImageView.height * 0.1f)];
//                         CGAffineTransform scakeTrans = CGAffineTransformMakeScale(0.1f, 0.1f);
//                         productImageView.transform = scakeTrans;
                     } completion:^(BOOL finished) {
                [productImageView removeFromSuperview];
                [self confirmationManager];
            }];

//    [self performSelector:@selector(CustomAnimation:) withObject:productImageView afterDelay:.5f];
}

//- (void)CustomAnimation:(id)imageView {
//    MMHImageView *productImageView = (MMHImageView *)imageView;
//    [UIView animateWithDuration:1.0f animations:^{
//
//        
//    } completion:^(BOOL finished) {
//
//    }];
//}


@end

//
//  QGHProductDetailVIewController.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/1.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductDetailVIewController.h"
#import "MMHProductDetailHeaderCell.h"
#import "QGHProductDetailPriceCell.h"
#import "QGHProductDetailCommentCell.h"
#import "QGHProductDetailInfoCell.h"
#import "QGHConfirmOrderViewController.h"
#import "MMHNetworkAdapter+Product.h"
#import "QGHProductDetailWebViewCell.h"
#import "MMHProductSpecSelectionViewController.h"
#import "MMHNetworkAdapter+Cart.h"
#import "MMHChatCustomerViewController.h"
#import "QGHCommentListViewController.h"
#import "QGHChatViewController.h"
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <SDWebImageManager.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


static NSString *const QGHProductDetailHeaderCellIdentifier = @"QGHProductDetailHeaderCellIdentifier";
static NSString *const QGHProductDetailPriceCellIdentifier = @"QGHProductDetailPriceCellIdentifier";
static NSString *const QGHProductDetailProductTitleCellIdentifier = @"QGHProductDetailProductTitleCellIdentifier";
static NSString *const QGHProductDetailCommentTitleCellIdentifier = @"QGHProductDetailCommentTitleCellIdentifier";
static NSString *const QGHProductCommentCellIdentifier = @"QGHProductCommentCellIdentifier";
static NSString *const QGHProductDetailImageTitleCellIdentifier = @"QGHProductDetailImageTitle";
static NSString *const QGHProductDetailImageCellIdentifier = @"QGHProductDetailImageCellIdentifier";


@interface QGHProductDetailVIewController ()<UITableViewDelegate, UITableViewDataSource, QGHProductDetailWebViewCellDelegate>

@property (nonatomic, assign) QGHBussType bussType;
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) CGFloat productDetaiImageHeight;

@property (nonatomic, strong) QGHProductDetailModel *productDetailModel;
@property (nonatomic, strong) QGHProductDetailScoreInfo *scoreInfo;
@property (nonatomic, strong) NSArray<QGHProductDetailComment *> *comments;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end


@implementation QGHProductDetailVIewController


- (instancetype)initWithBussType:(QGHBussType)type goodsId:(NSString *)goodsId {
    self = [super init];
    
    if (self) {
        _bussType = type;
        _goodsId = goodsId;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithTitle:@"评价" style:UIBarButtonItemStylePlain target:self action:@selector(commentAction)];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"xiangqing_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItems = @[shareItem, commentItem];
    
    self.dataSource = [@[@"goods", @"goodsDes"] mutableCopy];
    
    [self makeTableView];
    [self makeBottomView];
    [self fetchData];
}


- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[MMHProductDetailHeaderCell class] forCellReuseIdentifier:QGHProductDetailHeaderCellIdentifier];
    [_tableView registerClass:[QGHProductDetailPriceCell class] forCellReuseIdentifier:QGHProductDetailPriceCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHProductDetailInfoCell" bundle:nil] forCellReuseIdentifier:QGHProductDetailProductTitleCellIdentifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:QGHProductDetailCommentTitleCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"QGHProductDetailCommentCell" bundle:nil]forCellReuseIdentifier:QGHProductCommentCellIdentifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:QGHProductDetailImageTitleCellIdentifier];
    [_tableView registerClass:[QGHProductDetailWebViewCell class] forCellReuseIdentifier:QGHProductDetailImageCellIdentifier];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];
}


- (void)makeBottomView {
    _bottomView = [[UIView alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"pro_btn_kefu"];
    NSString *title = @"客服";
    CGSize titleSize = [title sizeWithFont:F3 constrainedToWidth:CGFLOAT_MAX lineCount:1];
    UIButton *customerServiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 48)];
    [customerServiceBtn setImage:image forState:UIControlStateNormal];
    [customerServiceBtn setTitle:title forState:UIControlStateNormal];
    customerServiceBtn.titleLabel.font = F3;
    [customerServiceBtn setTitleColor:C7 forState:UIControlStateNormal];
    [customerServiceBtn setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height, titleSize.width, 0, 0)];
    [customerServiceBtn setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height, -image.size.width, 0, 0)];
    [customerServiceBtn addTarget:self action:@selector(customerServiceBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:customerServiceBtn];
    
    image = [UIImage imageNamed:@"pro_btn_shopping_n"];
    title = @"购物车";
    titleSize = [title sizeWithFont:F3 constrainedToWidth:CGFLOAT_MAX lineCount:1];
    UIButton *cartBtn = [[UIButton alloc] initWithFrame:CGRectMake(75, 0, 75, 48)];
    [cartBtn setImage:image forState:UIControlStateNormal];
    [cartBtn setTitle:title forState:UIControlStateNormal];
    cartBtn.titleLabel.font = F3;
    [cartBtn setTitleColor:C7 forState:UIControlStateNormal];
    cartBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cartBtn setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height, (75 - image.size.width) * 0.5, 0, 0)];
    [cartBtn setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height, 0, 0, 0)];
    [cartBtn addTarget:self action:@selector(cartBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cartBtn];
    
    if (self.bussType == QGHBussTypeAppoint && self.bussType == QGHBussTypeCustom) {
        UIButton *appointBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, mmh_screen_width() - 150, 75)];
        appointBtn.backgroundColor = C20;
        [appointBtn setTitle:@"立即预约" forState:UIControlStateNormal];
        [appointBtn setTitleColor:C21 forState:UIControlStateNormal];
        appointBtn.titleLabel.font = F6;
        [_bottomView addSubview:appointBtn];
    } else {
        UIButton *addCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, (mmh_screen_width() - 150) * 0.5, 48)];
        addCartBtn.backgroundColor = C20;
        [addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [addCartBtn setTitleColor:C21 forState:UIControlStateNormal];
        addCartBtn.titleLabel.font = F6;
        [addCartBtn addTarget:self action:@selector(addCartBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:addCartBtn];
        
        UIButton *buyNowBtn = [[UIButton alloc] initWithFrame:CGRectMake(addCartBtn.right, 0, (mmh_screen_width() - 150) * 0.5, 48)];
        buyNowBtn.backgroundColor = RGBCOLOR(252, 43, 70);
        [buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyNowBtn.titleLabel.font = F6;
        [buyNowBtn addTarget:self action:@selector(buyNowBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:buyNowBtn];
    }
    [_bottomView addTopSeparatorLine];
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(mmh_screen_width());
        make.height.mas_equalTo(48);
    }];
}


#pragma mark - network


- (void)fetchData {
//    if (![[MMHAccountSession currentSession] alreadyLoggedIn]) {
//        return;
//    }
    
    [[MMHNetworkAdapter sharedAdapter] fetchDataWithRequester:self goodsId:self.goodsId succeededHandler:^(QGHProductDetailModel *productDetailModel) {
        self.productDetailModel = productDetailModel;
        [self.tableView reloadData];
    } failedHandler:^(NSError *error) {
        [self.view showTipsWithError:error];
    }];
    
    
    [[MMHNetworkAdapter sharedAdapter] fetchProductCommentsWithRequester:self goodsId:self.goodsId page:1 size:10 succeededHandler:^(QGHProductDetailScoreInfo *scoreInfo, NSArray<QGHProductDetailComment *> *commentArr) {
        self.scoreInfo = scoreInfo;
        self.comments = commentArr;
        if (commentArr.count > 0) {
            self.dataSource = [@[@"goods", @"comments", @"goodsDes"] mutableCopy];
        }
        [self.tableView reloadData];
    } failedHandler:^(NSError *error) {
//        [self.view showTipsWithError:error];
    }];
}


- (NSString *)nameForSection:(NSInteger)section {
    return self.dataSource[section];
}


#pragma mark - UITalbeView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self nameForSection:section] isEqualToString:@"goods"]) {
        return 3;
    } else if ([[self nameForSection:section] isEqualToString:@"comments"]) {
        NSInteger count = (self.comments.count > 2) ? 2 : self.comments.count;
        return 1 + count;
    } else {
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self nameForSection:indexPath.section] isEqualToString:@"goods"]) {
        if (indexPath.row == 0) {
            MMHProductDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailHeaderCellIdentifier forIndexPath:indexPath];
            cell.imageArray = self.productDetailModel.product.img_path;
            return cell;
        } else if (indexPath.row == 1) {
            QGHProductDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailPriceCellIdentifier forIndexPath:indexPath];
            [cell setData:self.productDetailModel];
            return cell;
        } else {
            QGHProductDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailProductTitleCellIdentifier forIndexPath:indexPath];
            [cell setData:self.productDetailModel];
            return cell;
        }
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"comments"]) {
        if (indexPath.row == 0) {
            NSString *star = [NSString stringWithFormat:@"%g", [self.scoreInfo.star floatValue]];
            if ([star rangeOfString:@"."].location != NSNotFound) {
                star = [NSString stringWithFormat:@"%.2f", [self.scoreInfo.star floatValue]];
            }
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailCommentTitleCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"商品评价(%@条，%@好评率)", self.scoreInfo.count, star];
            cell.textLabel.font = F5;
            cell.textLabel.textColor = C8;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else {
            QGHProductDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductCommentCellIdentifier forIndexPath:indexPath];
            QGHProductDetailComment *comment = self.comments[indexPath.row - 1];
            [cell setComment:comment];
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailImageTitleCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"商品介绍";
            cell.textLabel.font = F3;
            cell.textLabel.textColor = C6;
            
            return cell;
        } else {
            QGHProductDetailWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QGHProductDetailImageCellIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            [cell setProductDetailUrl:self.productDetailModel.product.info];
            
            return cell;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        QGHCommentListViewController *commentListVC = [[QGHCommentListViewController alloc] initWithGoodsId:self.productDetailModel.product.goodsId];
        [self.navigationController pushViewController:commentListVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self nameForSection:indexPath.section] isEqualToString:@"goods"]) {
        if (indexPath.row == 0) {
            return mmh_screen_width();
        } else if (indexPath.row == 1) {
            return 50;
        } else {
            return 95;
        }
    } else if ([[self nameForSection:indexPath.section] isEqualToString:@"comments"]) {
        if (indexPath.row == 0) {
            return 48;
        } else {
            return 89;
        }
    } else {
        if (indexPath.row == 0) {
            return 43;
        } else {
//            return 667;
            return self.productDetaiImageHeight;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.000001;
    } else {
        return 10;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}


#pragma mark - QGHProductDetailWebViewCellDelegate


- (void)productDetailWebViewCellLoadedFinish:(CGFloat)webViewContentHeight {
    self.productDetaiImageHeight = webViewContentHeight;
    [self.tableView reloadData];
}

#pragma mark - Action


- (void)shareAction {
    NSString *imageUr = self.productDetailModel.product.img_path.firstObject;
    if (imageUr.length == 0) {
        return;
    }
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUr] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self shareHandle:image];
    }];
}

- (void)shareHandle:(UIImage *)image {
//    UIImage *shareImage = [image scaledToFitSize:CGSizeMake(200, 200)];
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/fen-xiang/id1138627393?l=zh&ls=1&mt=8"];
    NSMutableDictionary *shareParameters = [NSMutableDictionary dictionary];
    [shareParameters SSDKSetupWeChatParamsByText:self.productDetailModel.product.title title:@"芬想" url:url thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeApp forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [shareParameters SSDKSetupWeChatParamsByText:self.productDetailModel.product.title title:@"芬想" url:url thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    [shareParameters SSDKSetupQQParamsByText:self.productDetailModel.product.title title:@"芬想" url:url thumbImage:nil image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    [shareParameters SSDKSetupQQParamsByText:self.productDetailModel.product.title title:@"芬想" url:url thumbImage:nil image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];

    dispatch_async(dispatch_get_main_queue(), ^{
        [ShareSDK showShareActionSheet:self.view items:nil shareParams:shareParameters onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            //TODO
        }];
    });
}

- (void)addCartBtnAction {
    if (![[MMHAccountSession currentSession] alreadyLoggedIn]) {
        [self presentLoginViewControllerWithSucceededHandler:^{
        }];
        return;
    }
    
    MMHProductSpecSelectionViewController *specVC = [[MMHProductSpecSelectionViewController alloc] initWithProductDetail:self.productDetailModel specSelectedHandler:^(QGHSKUSelectModel *selectedSpec) {
        [[MMHNetworkAdapter sharedAdapter] addCartFrom:self goodsId:self.productDetailModel.product.goodsId count:selectedSpec.count price:self.productDetailModel.product.discount_price skuId:self.productDetailModel.allSepcSelectedPrice.priceId succeededHandler:^{
            [self.view showTips:@"加入购物车成功"];
        } failedHandler:^(NSError *error) {
            [self.view showTipsWithError:error];
        }];
    }];
    QGHTabBarController *tabBarController = (QGHTabBarController *)self.tabBarController;
    [tabBarController presentFloatingViewController:specVC animated:YES];

}


- (void)buyNowBtnAction {
    if (![[MMHAccountSession currentSession] alreadyLoggedIn]) {
        [self presentLoginViewControllerWithSucceededHandler:^{
        }];
        return;
    }
    
    MMHProductSpecSelectionViewController *specVC = [[MMHProductSpecSelectionViewController alloc] initWithProductDetail:self.productDetailModel specSelectedHandler:^(QGHSKUSelectModel *selectedSpec) {
        QGHConfirmOrderViewController *confirmOrderVC = [[QGHConfirmOrderViewController alloc] initWithBussType:QGHBussTypeNormal productDetail:self.productDetailModel];
        [self.navigationController pushViewController:confirmOrderVC animated:YES];
    }];
    QGHTabBarController *tabBarController = (QGHTabBarController *)self.tabBarController;
    [tabBarController presentFloatingViewController:specVC animated:YES];
}


- (void)customerServiceBtnAction {
    if (![[MMHAccountSession currentSession] alreadyLoggedIn]) {
        [self presentLoginViewControllerWithSucceededHandler:^{
        }];
        return;
    }
    
    QGHChatViewController *chatVC = [[QGHChatViewController alloc] initWithProductInfo:self.productDetailModel.product];
    chatVC.customChatType = QGHChatTypeChat;
    [self.navigationController pushViewController:chatVC animated:YES];
//    MMHChatCustomerViewController *chatCustomerVC = [[MMHChatCustomerViewController alloc] init];
//    [self.navigationController pushViewController:chatCustomerVC animated:YES];
}


- (void)cartBtnAction {
    [QGHTabBarController redirectToCart];
}


- (void)commentAction {
    if (![[MMHAccountSession currentSession] alreadyLoggedIn]) {
        [self presentLoginViewControllerWithSucceededHandler:^{
        }];
        return;
    }
    
    QGHCommentListViewController *commentListVC = [[QGHCommentListViewController alloc] initWithGoodsId:self.productDetailModel.product.goodsId];
    [self.navigationController pushViewController:commentListVC animated:YES];
}


@end

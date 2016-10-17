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
#import "QGHProductPicViewController.h"
#import "EMSDK.h"
#import "MMHAccountSession.h"


#define FOOTER_JUMP_VIEW_HEIGHT 50


static NSString *const QGHProductDetailHeaderCellIdentifier = @"QGHProductDetailHeaderCellIdentifier";
static NSString *const QGHProductDetailPriceCellIdentifier = @"QGHProductDetailPriceCellIdentifier";
static NSString *const QGHProductDetailProductTitleCellIdentifier = @"QGHProductDetailProductTitleCellIdentifier";
static NSString *const QGHProductDetailCommentTitleCellIdentifier = @"QGHProductDetailCommentTitleCellIdentifier";
static NSString *const QGHProductCommentCellIdentifier = @"QGHProductCommentCellIdentifier";
static NSString *const QGHProductDetailImageTitleCellIdentifier = @"QGHProductDetailImageTitle";
static NSString *const QGHProductDetailImageCellIdentifier = @"QGHProductDetailImageCellIdentifier";


@interface QGHProductDetailVIewController ()<UITableViewDelegate, UITableViewDataSource, QGHProductDetailWebViewCellDelegate, QGHProductPicViewControllerDelegate>

@property (nonatomic, assign) QGHBussType bussType;
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) CGFloat productDetaiImageHeight;

@property (nonatomic, strong) QGHProductDetailModel *productDetailModel;
@property (nonatomic, strong) QGHProductDetailScoreInfo *scoreInfo;
@property (nonatomic, strong) NSArray<QGHProductDetailComment *> *comments;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIButton *addCartBtn;
@property (nonatomic, strong) UIButton *buyNowBtn;
@property (nonatomic, strong) UIButton *appointNowBtn;

@property (nonatomic, strong) QGHProductPicViewController *productPicViewController;
@property (nonatomic, strong) UIView *footerJumpView;
@end


@implementation QGHProductDetailVIewController


- (instancetype)initWithBussType:(QGHBussType)type goodsId:(NSString *)goodsId {
    self = [super init];
    
    if (self) {
        _bussType = (QGHBussType)type;
        _goodsId = goodsId;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithTitle:@"评价" style:UIBarButtonItemStylePlain target:self action:@selector(commentAction)];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [shareButton setImage:[UIImage imageNamed:@"fenxiang_ugly"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItems = @[shareItem, commentItem];
    
    self.dataSource = [@[@"goods", @"goodsDes"] mutableCopy];
    
    [self makeTableView];
    [self makeBottomView];
    [self makeProductPicViewController];
    [self fetchData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchData];
}


- (void)makeProductPicViewController {
    if (!self.productDetailModel) {
        _productPicViewController = [[QGHProductPicViewController alloc] init];
        _productPicViewController.view.frame = CGRectMake(0, self.view.height, mmh_screen_width(), self.view.height - 48);
        _productPicViewController.delegate = self;
        [self addChildViewController:_productPicViewController];
        [self.view addSubview:_productPicViewController.view];
    }
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
    _tableView.tableFooterView = [self createFooterJumpView];
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
    
    switch (self.bussType) {
        case QGHBussTypeAppoint:
        case QGHBussTypeCustom: {
            UIButton *appointBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, mmh_screen_width() - 150, 48)];
            appointBtn.backgroundColor = C20;
            [appointBtn setTitle:@"立即预约" forState:UIControlStateNormal];
            [appointBtn setTitleColor:C21 forState:UIControlStateNormal];
            appointBtn.titleLabel.font = F6;
            [appointBtn addTarget:self action:@selector(buyNowBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:appointBtn];
            break;
        }
        default: {
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
            break;
        }
    }
   
    [_bottomView addTopSeparatorLine];
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(mmh_screen_width());
        make.height.mas_equalTo(48);
    }];
}


- (UIView *)createFooterJumpView {
    UIView *footerJumpView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.contentSize.height, kScreenWidth, FOOTER_JUMP_VIEW_HEIGHT)];
    
    UIImageView *toUpImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_ic_toup"]];
    UILabel *toUpTip = [[UILabel alloc] init];
    toUpTip.textAlignment = NSTextAlignmentLeft;
    toUpTip.font = F3;
    toUpTip.textColor = C7;
    [toUpTip setSingleLineText:@"上拉查看图文详情"];
    [toUpImg setCenterY:footerJumpView.height * 0.5];
    [toUpTip setCenterY:toUpImg.centerY];
    CGFloat width = toUpImg.width + 5 + toUpTip.width;
    [toUpImg setX:(kScreenWidth - width) * 0.5];
    [toUpTip attachToRightSideOfView:toUpImg byDistance:5];
    [footerJumpView addSubview:toUpImg];
    [footerJumpView addSubview:toUpTip];
    self.footerJumpView = footerJumpView;
    //[self.productDetailTableView addSubview:footerJumpView];
    
    //[self.productDetailTableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    return footerJumpView;
}

#pragma mark - network


- (void)fetchData {
//    if (![[MMHAccountSession currentSession] alreadyLoggedIn]) {
//        return;
//    }
    
    [[MMHNetworkAdapter sharedAdapter] fetchDataWithRequester:self goodsId:self.goodsId succeededHandler:^(QGHProductDetailModel *productDetailModel) {
        self.productDetailModel = productDetailModel;
        [self.tableView reloadData];
        [self.productPicViewController setProductDetailUrl:self.productDetailModel.product.desc];
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
    if ([[self nameForSection:indexPath.section] isEqualToString:@"comments"] && indexPath.row == 0) {
        QGHCommentListViewController *commentListVC = [[QGHCommentListViewController alloc] initWithGoodsId:self.productDetailModel.product.goodsId];
        [self.navigationController pushViewController:commentListVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self nameForSection:indexPath.section] isEqualToString:@"goods"]) {
        if (indexPath.row == 0) {
            return mmh_screen_width() * 640 / 960;
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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.height - (scrollView.contentSize.height - scrollView.contentOffset.y) > 30) {
        [self showProductPicViewController];
    }
}

#pragma mark - QGHProductDetailWebViewCellDelegate


- (void)productDetailWebViewCellLoadedFinish:(CGFloat)webViewContentHeight {
    self.productDetaiImageHeight = webViewContentHeight;
    [self.tableView reloadData];
}


- (void)showProductPicViewController {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.y = -self.view.size.height;
        self.productPicViewController.view.y = 0;
    }];
}


#pragma mark - QGHProductPicViewControllerDelegate


- (void)scrollToTopBack {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.y = 0;
        self.productPicViewController.view.y = self.view.height;
    }];
    
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(mmh_screen_width());
        make.height.mas_equalTo(48);
    }];
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
    if (self.productDetailModel.product.shareurl.length > 0) {
        NSString *appendStr = [NSString stringWithFormat:@"&referee_id=%@", [[MMHAccountSession currentSession] userId]];
        NSString *shareUrlStr = [self.productDetailModel.product.shareurl stringByAppendingString:appendStr];
        url = [NSURL URLWithString:shareUrlStr];
    }
    
    NSMutableDictionary *shareParameters = [NSMutableDictionary dictionary];
    [shareParameters SSDKSetupWeChatParamsByText:self.productDetailModel.product.title title:@"芬想" url:url thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
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
    
    __weak typeof(self) weakSelf = self;
    MMHProductSpecSelectionViewController *specVC = [[MMHProductSpecSelectionViewController alloc] initWithProductDetail:self.productDetailModel specSelectedHandler:^(QGHSKUSelectModel *selectedSpec) {
        QGHConfirmOrderViewController *confirmOrderVC = [[QGHConfirmOrderViewController alloc] initWithBussType:QGHBussTypeNormal productDetail:self.productDetailModel];
        [weakSelf.navigationController pushViewController:confirmOrderVC animated:YES];
        [weakSelf sendPurchaseMessage];
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


#pragma mark - private methods


- (void)sendPurchaseMessage {
    NSString *msg = [NSString stringWithFormat:@"用户%@购买商品：%@", [[MMHAccountSession currentSession] userId], self.productDetailModel.product.title];
    NSString *chatter = self.productDetailModel.product.supplier;
    if (chatter.length == 0) {
        chatter = @"kefu";
    }
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:msg];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:chatter from:[[EMClient sharedClient] currentUsername] to:chatter body:body ext:nil];
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:nil];
}


@end

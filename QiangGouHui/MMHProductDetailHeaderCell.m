//
//  MMHProductDetailHeaderCell.m
//  MamHao
//
//  Created by SmartMin on 15/6/15.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#define SIDE_VIEW_WIDTH 50

#import "MMHProductDetailHeaderCell.h"


@interface MMHProductDetailHeaderCell()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *productImageViewScrollView;
//@property (nonatomic,strong)UILabel *pageLabel;
@property (nonatomic,strong)UIImageView *alphaImageView;
@property (nonatomic,strong)UIPageControl *pageControl;

@end

@implementation MMHProductDetailHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}


#pragma mark - createView


-(void)createView{
    // 创建ScrollView
    self.productImageViewScrollView = [[UIScrollView alloc] init];
    self.productImageViewScrollView.backgroundColor = [QGHAppearance backgroundColor];
    self.productImageViewScrollView.frame = CGRectMake(0, 0, kScreenBounds.size.width, MMHFloat(375));
    self.productImageViewScrollView.bounces = YES;
    self.productImageViewScrollView.showsHorizontalScrollIndicator = NO;
    self.productImageViewScrollView.showsVerticalScrollIndicator = NO;
    self.productImageViewScrollView.pagingEnabled = YES;
    self.productImageViewScrollView.delegate = self;
    self.productImageViewScrollView.directionalLockEnabled = YES;//锁定滑动的方向
    [self.contentView addSubview:self.productImageViewScrollView];
    
    // 创建pageBackground
    MMHImageView *pageBackgroundView = [[MMHImageView alloc] init];
    pageBackgroundView.frame = CGRectMake(kScreenBounds.size.width - MMHFloat(10) - MMHFloat(40), MMHFloat(375) - MMHFloat(10) - MMHFloat(40), MMHFloat(40), MMHFloat(40));
    pageBackgroundView.isCircularFaceImage = YES;
    pageBackgroundView.image = [UIImage imageNamed:@"pro_ic_tuwenxq"];
//    pageBackgroundView.actionBlock = ^{
//        //TODO:-fish
//        NSLog(@"到商品详情");
//        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(imageScrollToLast)]) {
//            [self.delegate imageScrollToLast];
//        }
//    };
    [self.contentView addSubview:pageBackgroundView];
    
//    self.pageLabel = [[UILabel alloc] init];
//    self.pageLabel.textColor = [UIColor whiteColor];
//    self.pageLabel.backgroundColor = [UIColor clearColor];
//    self.pageLabel.frame = pageBackgroundView.frame;
//    self.pageLabel.textAlignment = NSTextAlignmentCenter;
//    self.pageLabel.hidden = YES;
//    [self.contentView addSubview:self.pageLabel];

    // 5. 创建阴影imageView  pro_bg_blackshadow
    UIImageView *alphaImageView = [[UIImageView alloc] init];
    alphaImageView.backgroundColor = [UIColor clearColor];
    alphaImageView.image = [UIImage imageNamed:@"pro_bg_blackshadow"];
    alphaImageView.frame = CGRectMake(0, MMHFloat(375) - MMHFloat(20), kScreenBounds.size.width, MMHFloat(20));
    [self.contentView addSubview:alphaImageView];
    
//    // 6. 创建pageControl
}

-(void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    // 1. 创建图片
    [self.productImageViewScrollView removeAllSubviews];
    if (imageArray.count != 0){
        if (self.productImageViewScrollView.subviews.count == 0){
            for (int i = 0 ; i < imageArray.count ; i++){
                MMHImageView *productImageView = [[MMHImageView alloc] init];
                productImageView.backgroundColor = [UIColor clearColor];
                productImageView.stringTag = @"productImageView";
                productImageView.frame = CGRectMake(0 + i * kScreenBounds.size.width, 0,kScreenBounds.size.width, MMHFloat(375));
                [self.productImageViewScrollView addSubview:productImageView];
                //[productImageView updateViewWithImageAtURL:[imageArray objectAtIndex:i]];
                [productImageView updateViewWithImageAtURL:[imageArray objectAtIndex:i] withQuality:80 finishBlock:nil];
//                __weak __typeof(self) weakSelf = self;
//                productImageView.actionBlock = ^{
//                  
//                    if (!weakSelf) {
//                        return ;
//                    }
//                    __strong typeof(weakSelf)strongSelf =weakSelf;
//                    [[MMHImageBrowser sharedImageBrowser] showImage:strongSelf.productImageViewScrollView.subviews currentIndex:i imageDatasource:imageArray callBack:^(NSInteger currentPage) {
//                        strongSelf.productImageViewScrollView.contentOffset = CGPointMake(currentPage * kScreenWidth, 0);
//                    }];
//                };
            }
//            [self createSideView];
        }
        self.productImageViewScrollView.contentSize = CGSizeMake(imageArray.count * kScreenBounds.size.width, 0);
//        [self setPageLabelTextWithScrllView:self.productImageViewScrollView];
    }
    
    // 创建pageControl
    if (self.pageControl == nil) {
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.userInteractionEnabled = NO;
//        _pageControl.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.2f];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"BFBEBE"];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"FC687C"];
        [self.contentView addSubview:self.pageControl];
        
        CGSize size = [self.pageControl sizeForNumberOfPages:imageArray.count];
        CGRect frame = self.pageControl.frame;
        frame.size = CGSizeMake(size.width, 7);
        frame.origin = CGPointMake((self.width - size.width) / 2 , MMHFloat(375) - MMHFloat(17));
        self.pageControl.frame = frame;
        self.pageControl.numberOfPages = imageArray.count;
        self.pageControl.hidesForSinglePage = YES;
    }
}


//- (void)setPageLabelTextWithScrllView:(UIScrollView *)scrollView{
//    NSInteger page =  scrollView.contentOffset.x/kScreenWidth;
//    NSString *string = [NSString stringWithFormat:@"%ld/%lu", page+1, (unsigned long)self.imageArray.count];
//    NSMutableAttributedString *attrbuteString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSDictionary *dic1 = @{NSFontAttributeName:MMHF6};
//    NSRange range1 = NSMakeRange(0, 1);
//    
//    NSDictionary *dic2= @{NSFontAttributeName:MMHF4};
//    NSRange range2 = NSMakeRange(2, 1);
//    [attrbuteString addAttributes:dic1 range:range1];
//    [attrbuteString addAttributes:dic2 range:range2];
//    self.pageLabel.attributedText = attrbuteString;
//}
//

//- (void)createSideView {
//    UIView *sideView = [[UIView alloc] initWithFrame:CGRectMake(self.imageArray.count * kScreenWidth, 0, SIDE_VIEW_WIDTH, self.productImageViewScrollView.height)];
//    sideView.backgroundColor = [QGHAppearance backgroundColor];
//    
//    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_ic_toleft"]];
//    [arrowImg setX:10];
//    [arrowImg setCenterY:sideView.height / 2];
//    [sideView addSubview:arrowImg];
//    
//    UILabel *sideViewTip = [[UILabel alloc] init];
//    sideViewTip.textColor = C4;
//    sideViewTip.font = F3;
//    [sideViewTip setSingleVerticalLineChineseText:@"继续滑动查看图文详情"];
//    [sideViewTip attachToRightSideOfView:arrowImg byDistance:10];
//    [sideViewTip setCenterY:arrowImg.centerY];
//    [sideView addSubview:sideViewTip];
//    
//    [self.productImageViewScrollView addSubview:sideView];
//}


#pragma mark UIScrollViewDelegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.productImageViewScrollView){
        //NSInteger page = scrollView.contentOffset.x/ kScreenBounds.size.width;
        //self.dynamicPageLabel.text = [NSString stringWithFormat:@"%li",(long)page + 1];
//        [self setPageLabelTextWithScrllView:scrollView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView.contentOffset.x > (self.imageArray.count - 1) * kScreenWidth + SIDE_VIEW_WIDTH) {
//        if ([self.delegate respondsToSelector:@selector(imageScrollToLast)]) {
//            [self.delegate imageScrollToLast];
//        }
//    }
//}

@end

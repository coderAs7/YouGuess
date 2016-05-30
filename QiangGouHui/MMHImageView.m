////
////  MMHImageView.m
////  MamHao
////
////  Created by Louis Zhu on 15/5/27.
////  Copyright (c) 2015年 Mamhao. All rights reserved.
////
//
//#import "MMHImageView.h"
//#import "SDImageCache.h"
//#import "UIImageView+WebCache.h"
//
//
//@interface MMHImageView ()
//
//@property (nonatomic, copy) NSString *updatingImageURLString;
//@end
//
//
//@implementation MMHImageView
//
//
//- (void)setPlaceholderImageName:(NSString *)placeholderImageName
//{
//    _placeholderImageName = placeholderImageName;
//
//    [self updateViewWithPlaceholderImage];
//}
//
//- (void)setActionBlock:(MMHImageViewActionBlock)actionBlock
//{
//    _actionBlock = [actionBlock copy];
//    
//    if (actionBlock) {
//        self.userInteractionEnabled = YES;
//    }
//    else {
//        self.userInteractionEnabled = NO;
//    }
//}
//
//
////- (void)setDoubleTapBlock:(MMHImageViewDoubleTapAction)doubleTapBlock {
////    _doubleTapBlock = [doubleTapBlock copy];
////    if (doubleTapBlock) {
////        self.userInteractionEnabled = YES;
////    } else {
////        self.userInteractionEnabled = NO;
////    }
////}
////
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.contentMode = UIViewContentModeScaleAspectFill;
//        self.clipsToBounds = YES;
//        self.shouldClearPreviousImageWhenUpdating = YES;
//        [self updateViewWithPlaceholderImage];
////        self.userInteractionEnabled = YES;
//        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beenTapped:)];
//        gr.numberOfTapsRequired = 1;
//        gr.numberOfTouchesRequired = 1;
//        gr.cancelsTouchesInView = NO;
//        [self addGestureRecognizer:gr];
////        UITapGestureRecognizer *tappeDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beenTappedDouble:)];
////        tappeDouble.numberOfTapsRequired = 2;
////        tappeDouble.numberOfTouchesRequired = 1;
////        tappeDouble.cancelsTouchesInView = NO;
////        [self addGestureRecognizer:tappeDouble];
//        self.defaultContentMode=UIViewContentModeScaleAspectFill;
//    }
//    return self;
//}
//
//
//- (void)updateViewWithImageAtURL:(NSString *)urlString
//{
//    [self updateViewWithImageAtURL:urlString finishBlock:nil];
//}
//
//- (void)updateViewWithImageAtURL:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock
//{
//    [self updateViewWithImageAtURL:urlString withQuality:100 finishBlock:finishBlock];
//}
//
//
//- (void)updateViewWithImageAtURL:(NSString *)urlString withQuality:(int)quality finishBlock:(dispatch_block_t)finishBlock {
//    if(![urlString isKindOfClass:[NSString class]]){
//        [self updateViewWithImage:nil];
//        return;
//    }
//    
//    if ([urlString length] == 0) {
//        [self updateViewWithImage:nil];
//        return;
//    }
//    
////    NSString *actualURLString = urlString;
//    
//    /*
//     temData.getGoodsPic()+"@1e_200w_200h_0c_0i_0o_60q_1x.jpg"
//     */
//    
////    if (![urlString hasPrefix:@"http://"]) {
////        actualURLString = [NSString stringWithFormat:@"http://image.weixiao1688.com/%@", urlString];
////#if defined (API_MAMAHAO_COM)
////        actualURLString = [NSString stringWithFormat:@"http://img.mamahao.com/%@", urlString];
////#endif
////        if (self.urlPrefixString.length != 0) {
////            actualURLString = [NSString stringWithFormat:@"%@%@", self.urlPrefixString, urlString];
////        }
////    }
//    
//    //    NSLog(@"url string: %@", urlString);
//    //    NSLog(@"actual string: %@", actualURLString);
////        NSLog(@"url string: %@", urlString);
//    
////    NSInteger expectedWidth = (NSInteger)(self.frame.size.width * mmh_screen_scale());
////    NSInteger expectedHeight = (NSInteger)(self.frame.size.height * mmh_screen_scale());
////    NSString *croppedImageURLString = [actualURLString stringByAppendingFormat:@"@%ldw_%ldh_1e_%dq", (long)expectedWidth, (long)expectedHeight, quality];
////    if (self.imageContentMode == MMHImageViewContentModeFitWidth) {
////        croppedImageURLString = [actualURLString stringByAppendingFormat:@"@%ldw_1e_%dq", (long)expectedWidth, quality];
////    }
//////    NSLog(@"%@", croppedImageURLString);
////    if ([urlString hasSuffix:@".png"]) {
////        croppedImageURLString = [croppedImageURLString stringByAppendingString:@".png"];
////    }
////
////    if (((![actualURLString hasPrefix:MMHImageDomainName1]) && (![actualURLString hasPrefix:MMHImageDomainName2]) && (![actualURLString hasPrefix:MMHImageDomainName3]) && (![actualURLString hasPrefix:MMHImageDomainName4]) && (![actualURLString hasPrefix:MMHImageDomainName5]) && (![actualURLString hasPrefix:MMHImageDomainName6]) && (![actualURLString hasPrefix:MMHImageDomainName7])) || (self.imageCroppingDisabled)) {
////        croppedImageURLString = actualURLString;
////    }
//
//    if ([self.updatingImageURLString length] != 0) {
//        if ([self.updatingImageURLString isEqualToString:urlString]) {
//            return;
//        }
//    }
//    
//    self.updatingImageURLString = urlString;
//    
//    if (self.shouldClearPreviousImageWhenUpdating) {
//        [self updateViewWithImage:nil];
//    }
//    __weak __typeof(self) weakSelf = self;
//    
//    //    NSLog(@"cropped string: %@", croppedImageURLString);
//    
//    NSString *finalURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:finalURLString];
//    [self sd_setImageWithURL:url
//            placeholderImage:nil
//                     options:0
//                    progress:nil
//                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image == nil || error) {
//            weakSelf.updatingImageURLString = nil;
//            //                                                  [MMHLogbook logEvent:@"imageCannotBeFetched" withParameters:@{@"url": [imageURL absoluteString]}];
//            return;
//        }
//        UIImage *actualImage = [UIImage imageWithCGImage:image.CGImage scale:mmh_screen_scale() orientation:image.imageOrientation];
//        if (self.isCircularFaceImage) {
//            actualImage = [weakSelf.image centerSquareImage];
//            actualImage = [actualImage imageByRoundCornerRadius:actualImage.size.height borderWidth:weakSelf.circularBorderWidth borderColor:weakSelf.circularBorderColor];
//        }
//        [self updateViewWithImage:actualImage];
//        if (finishBlock != nil) {
//            dispatch_async(dispatch_get_main_queue(), finishBlock);
//        }
//    }];
//}
//
//
//
//
//
//
//- (void)updateViewWithImage:(UIImage *)image
//{
//    if (image == nil) {
//        self.updatingImageURLString = nil;
//        [self updateViewWithPlaceholderImage];
//        return;
//    }
//    self.contentMode = self.defaultContentMode;
//    self.image = image;
//}
//
//
//
//- (void)updateViewWithPlaceholderImage
//{
//    if ([self.placeholderImageName length] != 0) {
//        UIImage *image = [UIImage imageNamed:self.placeholderImageName];
//        if (image) {
//            if ((image.size.width < self.width) && (image.size.height < self.height)) {
//                self.contentMode = UIViewContentModeCenter;
//            }
//            
//            if(self.isCircularFaceImage) {
//                image = [image centerSquareImage];
//                image = [image imageByRoundCornerRadius:image.size.height borderWidth:self.circularBorderWidth borderColor:self.circularBorderColor];
//            }
//            
//            self.image = image;
//            
//            return;
//        }
//    }
//    
////    self.backgroundColor = [QGHAppearance separatorColor];
////    
////    NSString *imageName = @"mamahao_placeholder_120";
////    if (self.width * self.height > 150.0f * 150.0f) {
////        imageName = @"mamahao_placeholder_300";
////    }
////    if (self.width * self.height > 350.0f * 350.0f) {
////        imageName = @"mamahao_placeholder_700";
////    }
////
////    self.image = [UIImage imageNamed:imageName];
//    
//    self.image = [UIImage patternImageWithColor:[QGHAppearance separatorColor]];
//}
//
//
//
////- (void)beenTappedDouble:(UITapGestureRecognizer *)sender {
////    if (self.doubleTapBlock != nil) {
////        self.doubleTapBlock();
////    }
////}
//
//- (void)beenTapped:(UITapGestureRecognizer *)gr
//{
//    if (self.actionBlock != nil) {
//        self.actionBlock();
//    }
//}
//
//
//
//
//
//
//@end

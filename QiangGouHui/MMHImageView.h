//
//  MMHImageView.h
//  MamHao
//
//  Created by Louis Zhu on 15/5/27.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MMHImageViewContentMode) {
    MMHImageViewContentModeStandard,
    MMHImageViewContentModeFitWidth,
};


typedef void (^MMHImageViewActionBlock)();
typedef void (^MMHImageViewDoubleTapAction)();


@interface MMHImageView : UIImageView

@property (nonatomic) BOOL shouldClearPreviousImageWhenUpdating;
@property (nonatomic, copy) MMHImageViewActionBlock actionBlock;
//@property (nonatomic, copy) MMHImageViewDoubleTapAction doubleTapBlock;

- (void)updateViewWithImageAtURL:(NSString *)urlString;
- (void)updateViewWithImageAtURL:(NSString *)urlString finishBlock:(dispatch_block_t)finishBlock;
- (void)updateViewWithImageAtURL:(NSString *)urlString withQuality:(int)quality finishBlock:(dispatch_block_t)finishBlock;
- (void)updateViewWithImageAtURL:(NSString *)urlString finishWithImageBolck:(void (^)(UIImage *image))block;
- (void)updateViewWithImage:(UIImage *)image;

@property (nonatomic, copy) NSString *placeholderImageName;

@property (nonatomic, copy) NSString *urlPrefixString;

@property (nonatomic) BOOL imageCroppingDisabled;
@property (nonatomic) MMHImageViewContentMode imageContentMode;

@property (nonatomic) UIViewContentMode defaultContentMode;

@property (nonatomic , assign) BOOL isCircularFaceImage;
@property (nonatomic, assign) CGFloat circularBorderWidth;
@property (nonatomic, copy) UIColor *circularBorderColor;

@end

//
//  QGHProductInfoMessageCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/31.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHProductInfoMessageCell.h"
#import "EaseBubbleView+Custom.h"
#import "QGHMessageProductModel.h"


@implementation QGHProductInfoMessageCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    
    if (self) {
//        self.backgroundColor = [UIColor blueColor];
        if ([self.class isProductInfoMessage:model.text]) {
//            self.bubbleMaxWidth = SCREEN_WIDTH;
//            self.leftBubbleMargin = UIEdgeInsetsMake(0, 7, 0, 0);
//            self.rightBubbleMargin = UIEdgeInsetsMake(0, 0, 0, 7);
        }
    }
    
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_bubbleView bringSubviewToFront:_bubbleView.customView];
}


#pragma mark - IModelCell

- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
    BOOL flag = NO;
//    NSString *jsonStr = [Public getJSONInfoWithEMMessageText:model.text];
    if ([self.class isProductInfoMessage:model.text]) {
        flag = YES;
    }
    
    return flag;
}

- (void)setCustomModel:(id<IMessageModel>)model
{
//        UIImage *image = model.image;
//        if (!image) {
//            [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
//        } else {
//            _bubbleView.imageView.image = image;
//        }
//    
//        if (model.avatarURLPath) {
//            [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
//        } else {
//            self.avatarView.image = model.avatarImage;
//        }
//    
//        [_bubbleView.customView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(100);
//        }];
}

- (void)setCustomBubbleView:(id<IMessageModel>)model
{
//    self.bubbleView.backgroundColor = [UIColor yellowColor];
//    NSString *jsonStr = [Public getJSONInfoWithEMMessageText:model.text];
    if ([self.class isProductInfoMessage:model.text]) {
        QGHMessageProductModel *product = [[QGHMessageProductModel alloc] initWithJSONDict:[self productDict:model.text]];
        UIView *productInfoView = [[UIView alloc] init];
//        productInfoView.backgroundColor = [UIColor greenColor];
        
        MMHImageView *imageView = [[MMHImageView alloc] init];
//        imageView.backgroundColor = [UIColor redColor];
        [imageView updateViewWithImageAtURL:product.pic];
        [productInfoView addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.preferredMaxLayoutWidth = 80;
        nameLabel.numberOfLines = 4;
        nameLabel.textColor = C8;
        nameLabel.font = F3;
        nameLabel.text = product.itemName;
        [productInfoView addSubview:nameLabel];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = C22;
        priceLabel.font = F3;
        priceLabel.text = [NSString stringWithFormat:@"¥%@", product.price];
        [productInfoView addSubview:priceLabel];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.mas_equalTo(0);
            make.width.and.height.mas_equalTo(80);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView);
            make.left.equalTo(imageView.mas_right).offset(10);
        }];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(10);
            make.left.equalTo(imageView.mas_right).offset(10);
        }];
        
        [productInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(80);
            make.right.equalTo(nameLabel.mas_right).offset(10);
        }];
        
        [_bubbleView setupCustomView:productInfoView];
        
        [_bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(productInfoView).offset(20);
        }];
//        if (!model.isSender) {
//            [_bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(-15);
//            }];
//        } else {
//            [_bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(15);
//            }];
//        }
    }
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
//    NSString *jsonStr = [Public getJSONInfoWithEMMessageText:model.text];
    if ([self.class isProductInfoMessage:model.text]) {
        [_bubbleView updateCustomViewMargin:bubbleMargin];
    }
}


+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
//    NSString *jsonStr = [Public getJSONInfoWithEMMessageText:model.text];
    if ([self isProductInfoMessage:model.text]) {
        return model.isSender?@"ConsultMessageCellSend":@"ConsultMessageCellRecv";
    } else {
        return [EaseBaseMessageCell cellIdentifierWithModel:model];
    }
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    //    EaseBaseMessageCell *cell = [self appearance];
    //
    //    CGFloat minHeight = cell.avatarSize + EaseMessageCellPadding * 2;
    //    CGFloat height = cell.messageNameHeight;
    //    if ([UIDevice currentDevice].systemVersion.floatValue == 7.0) {
    //        height = 15;
    //    }
    //    height += - EaseMessageCellPadding + [EaseMessageCell cellHeightWithModel:model];
    //    height = height > minHeight ? height : minHeight;
//    NSString *jsonStr = [Public getJSONInfoWithEMMessageText:model.text];
//    if (jsonStr) {
//        return 15 + 8 + [ConsultChatHeaderView heightWithMessageModel:model constrainWidth: CONSULTION_VIEW_WIDTH] + 10;
//    } else {
//        return [EaseBaseMessageCell cellHeightWithModel:model];
//    }
    //    return 100;
    //    return height;
    //    return 100;
    if ([self isProductInfoMessage:model.text]) {
        return 15 + 10 + 80 + 10 + 10;
    }
    else {
        return [EaseBaseMessageCell cellHeightWithModel:model];
    }
}


#pragma mark - private methods


+ (BOOL)isProductInfoMessage:(NSString *)message {
    NSString *prefix = @"{\"item\":{";
    if ([message hasPrefix:prefix]) {
        return YES;
    }
    
    return NO;
}


- (NSDictionary *)productDict:(NSString *)prodctJson {
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[prodctJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    return [jsonDict objectForKey:@"item"];
}

@end

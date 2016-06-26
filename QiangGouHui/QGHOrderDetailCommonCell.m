//
//  QGHOrderDetailCommonCell.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/6/26.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "QGHOrderDetailCommonCell.h"

@implementation QGHOrderDetailCommonCell


+ (CGFloat)heightWithData:(NSArray *)dataArr {
    NSString *testString = @"苹果";
    CGFloat height = [testString sizeWithFont:F3 constrainedToWidth:CGFLOAT_MAX lineCount:1].height;
    return height * dataArr.count + 15 * (dataArr.count + 1);
}


- (void)setData:(NSArray *)dataArr {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat originY = 0;
    for (NSDictionary *dict in dataArr) {
        NSString *key = dict[@"key"];
        UILabel *keyLabel = [self makeKeyLabel:key];
        keyLabel.x = 15;
        keyLabel.y = originY + 15;
        [self.contentView addSubview:keyLabel];
        
        NSString *value = dict[@"value"];
        UILabel *valueLabel = [self makeValueLabel:value];
        valueLabel.x = mmh_screen_width() - 15 - valueLabel.width;
        valueLabel.y = originY + 15;
        [self.contentView addSubview:valueLabel];
        
        originY += 15 + keyLabel.height;
    }
}


- (UILabel *)makeKeyLabel:(NSString *)key {
    UILabel *label = [[UILabel alloc] init];
    label.text = key;
    label.textColor = C8;
    label.font = F3;
    [label sizeToFit];
    return label;
}


- (UILabel *)makeValueLabel:(NSString *)value {
    UILabel *label = [[UILabel alloc] init];
    label.text = value;
    label.textColor = RGBCOLOR(252, 43, 70);
    label.font = F3;
    [label sizeToFit];
    return label;
}


@end

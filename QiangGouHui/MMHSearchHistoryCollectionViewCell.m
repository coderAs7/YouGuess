//
//  MMHSearchHistoryCollectionViewCell.m
//  MamHao
//
//  Created by fishycx on 15/5/19.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import "MMHSearchHistoryCollectionViewCell.h"

@interface MMHSearchHistoryCollectionViewCell ()

@property (nonatomic, strong)UILabel *historyLabel;
@property (nonatomic, strong)UIButton *searchIcon;
@end
@implementation MMHSearchHistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.searchIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchIcon.frame = CGRectMake(0, 0,MMHFloat(20), 44);
        [_searchIcon setImage:[UIImage imageNamed:@"seach_ic"] forState:UIControlStateNormal];
        [self.contentView addSubview:_searchIcon];
        CGRect frame = CGRectMake(CGRectGetMaxX(_searchIcon.frame) + MMHFloat(10), 0, self.bounds.size.width - CGRectGetMaxY(_searchIcon.frame) - MMHFloat(10) , 39.5);
        self.historyLabel = [[UILabel alloc] initWithFrame: frame];
        _historyLabel.font = MMHFontOfSize(14);
        _historyLabel.textColor = [UIColor blackColor];
        self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_historyLabel.frame), self.bounds.size.width, 0.5)];
        _line.backgroundColor = [QGHAppearance separatorColor];
        [self.contentView addSubview:_line];
        [self.contentView addSubview:_historyLabel];
    }
    return self;
}

- (void)setKeyWord:(NSString *)keyWord {
    _keyWord = keyWord;
    self.historyLabel.text = keyWord;
}

@end

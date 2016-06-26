//
//  MMHUnderlinedSegmentedControl.m
//  MamHao
//
//  Created by Louis Zhu on 16/3/9.
//  Copyright © 2016年 Mamahao. All rights reserved.
//

#import "MMHUnderlinedSegmentedControl.h"


@implementation MMHUnderlinedSegmentedControl


//- (void)setFont:(UIFont *)font {
//    _font = font;
//    [self setTitleFont:font forState:UIControlStateNormal];
//}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isWordOfMouth) {
        CGFloat itemWidth = (self.bounds.size.width - 30) / 3;
        CGSize itemSize = CGSizeMake(itemWidth, self.bounds.size.height);
        return itemSize;
    }
    
    if (self.isNotScroll) {
        CGFloat itemWidth = (self.bounds.size.width - 20) / 2;
        CGSize itemSize = CGSizeMake(itemWidth, self.bounds.size.height);
        return itemSize;
    }
    
    return [super collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (void)setSelectedButtonIndex:(NSInteger)index animated:(BOOL)animated {
    NSInteger itemCount = [self.dataSource numberOfItemsInSelectionList:self];
    if (index >= itemCount) {
        return;
    }
    
    [super setSelectedButtonIndex:index animated:animated];
}

@end

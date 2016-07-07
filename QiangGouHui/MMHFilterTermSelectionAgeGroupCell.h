//
//  MMHFilterTermSelectionAgeGroupCell.h
//  MamHao
//
//  Created by Louis Zhu on 15/4/13.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

#import <UIKit/UIKit.h>


//@class FilterTermAge;


@interface MMHFilterTermSelectionAgeGroupCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL selectable;
//@property (nonatomic, strong) FilterTermAge *term;

//+ (CGSize)sizeWithTerm:(FilterTermAge *)term;


// for product spec selection
//@property (nonatomic, strong) NSString *title;
//+ (CGSize)sizeWithString:(NSString *)string;

@end

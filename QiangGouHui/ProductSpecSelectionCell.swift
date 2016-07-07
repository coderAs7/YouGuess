//
//  ProductSpecSelectionCell.swift
//  MamHao
//
//  Created by Louis Zhu on 15/10/19.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

import Foundation


class ProductSpecSelectionCell: MMHFilterTermSelectionAgeGroupCell {
    
    var title: String = "" {
        didSet {
            
            if title.characters.count == 0 {
                self.titleLabel.text = ""
                self.selected = false
            }
            else {
                self.titleLabel.setSingleLineText(title)
                self.titleLabel.frame = self.bounds
            }
            /*
            - (void)setTitle:(NSString *)title
            {
            _title = title;
            
            if (title == nil) {
            self.titleLabel.text = @"";
            self.selected = NO;
            }
            else {
            [self.titleLabel setSingleLineText:title constrainedToWidth:CGFLOAT_MAX];
            self.titleLabel.frame = self.bounds;
            }
            }

*/
        }
    }
    
    class func sizeWithString(string: String) -> CGSize {
        let cocoaString = string as NSString
        var stringSize = cocoaString.sizeWithSingleLineFont(F4)
        stringSize.width += 14
        let minSize = CGSizeMake(70, 30)
        return CGSizeMake(max(stringSize.width, minSize.width), max(stringSize.height, minSize.height));
    }
}

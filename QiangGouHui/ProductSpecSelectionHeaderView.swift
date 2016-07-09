//
//  MMHProductSpecSelectionHeaderView.swift
//  MamHao
//
//  Created by Louis Zhu on 15/4/16.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

import UIKit


class ProductSpecSelectionHeaderView: UICollectionReusableView {
    
    let titleLabel: MMHTextLabel
    var topSeparatorLine: UIView?
    var shouldShowTopSeparatorLine: Bool = true {
        didSet {
            if (shouldShowTopSeparatorLine) {
                if self.topSeparatorLine == nil {
                    let topSeparatorLine = UIView(frame: CGRectMake(10, 0, mmh_screen_width() - 20, mmh_pixel()))
                    topSeparatorLine.backgroundColor = QGHAppearance.separatorColor()
                    self.addSubview(topSeparatorLine)
                    self.topSeparatorLine = topSeparatorLine
                }
            }
            else {
                if self.topSeparatorLine != nil {
                    self.topSeparatorLine!.removeFromSuperview()
                    self.topSeparatorLine = nil
                }
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        self.titleLabel = MMHTextLabel(frame: CGRectMake(10, 0, 0, 45))
        self.titleLabel.centerY = 22.5
        self.titleLabel.width = mmh_screen_width() - 20
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.titleLabel.font = F6
        self.titleLabel.textColor = C8
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()

        self.addSubview(self.titleLabel)
    }

}

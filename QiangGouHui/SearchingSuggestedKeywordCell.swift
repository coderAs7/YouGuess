//
//  SearchingSuggestedKeywordCell.swift
//  MamHao
//
//  Created by Louis Zhu on 15/11/5.
//  Copyright © 2015年 Mamahao. All rights reserved.
//

import UIKit


@objc(MMHSearchingSuggestedKeywordCell)
class SearchingSuggestedKeywordCell: UITableViewCell {
    
    var keyword: String? {
        didSet {
            if keyword == nil {
                self.textLabel?.text = ""
            }
            else {
                self.textLabel?.text = keyword
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addBottomSeparatorLine()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

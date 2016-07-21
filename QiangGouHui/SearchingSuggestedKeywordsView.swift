//
//  SearchingSuggestedKeywordsView.swift
//  MamHao
//
//  Created by Louis Zhu on 15/11/5.
//  Copyright © 2015年 Mamahao. All rights reserved.
//

import UIKit


let MMHSearchingSuggestedKeywordsViewCellIdentifier = "MMHSearchingSuggestedKeywordsViewCellIdentifier"


@objc(MMHSearchingSuggestedKeywordsViewDelegate)
protocol SearchingSuggestedKeywordsViewDelegate: NSObjectProtocol {
    func searchingSuggestedKeywordsView(searchingSuggestedKeywordsView: SearchingSuggestedKeywordsView, didSelectKeyword keyword: String)
}


@objc(MMHSearchingSuggestedKeywordsView)
class SearchingSuggestedKeywordsView: UIView {
    
    weak var delegate: SearchingSuggestedKeywordsViewDelegate?
    
    var tableView: UITableView?
    var keyword = ""
    var keywords = [String]() {
        didSet {
            self.tableView?.reloadData()
            
//            if (keywords.count == 0) {
//                self.hidden = true
//            }
//            else {
//                self.hidden = false
//            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tableView = UITableView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(SearchingSuggestedKeywordCell.self, forCellReuseIdentifier: MMHSearchingSuggestedKeywordsViewCellIdentifier)
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(tableView)
        self.tableView = tableView
        
        SearchingSuggestedKeywordsManager.sharedManager.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


// MARK: - Table Views


extension SearchingSuggestedKeywordsView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keywords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MMHSearchingSuggestedKeywordsViewCellIdentifier) as! SearchingSuggestedKeywordCell
        let cocoaKeywords = self.keywords as NSArray
        let keyword = cocoaKeywords.nullableObjectAtIndex(indexPath.row) as? String
        cell.keyword = keyword
//        if let keyword = cocoaKeywords.nullableObjectAtIndex(indexPath.row) as? String {
//            cell?.textLabel?.text = keyword
//        }
//        else {
//            cell?.textLabel?.text = ""
//        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? SearchingSuggestedKeywordCell
        if cell == nil {
            return
        }
        
        let keyword = cell!.keyword
        self.delegate?.searchingSuggestedKeywordsView(self, didSelectKeyword: keyword!)
    }
}


// MARK: - APIs


extension SearchingSuggestedKeywordsView {
    
    func updateWithKeyword(keyword: String) {
        self.keyword = keyword
        let keywords = SearchingSuggestedKeywordsManager.sharedManager.suggestedKeywordsForKeyword(keyword)
        self.keywords = keywords
    }
    
}


// MARK: - SearchingSuggestedKeywordsManagerDelegate


extension SearchingSuggestedKeywordsView: SearchingSuggestedKeywordsManagerDelegate {
    func searchingSuggestedKeywordsManager(searchingSuggestedKeywordsManager: SearchingSuggestedKeywordsManager, suggestedKeywordsFetched suggestedKeywords: [String], forKeyword keyword: String) {
        if keyword == self.keyword {
            self.keywords = suggestedKeywords
        }
    }
}



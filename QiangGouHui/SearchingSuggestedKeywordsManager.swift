//
//  SearchingSuggestedKeywordsManager.swift
//  MamHao
//
//  Created by Louis Zhu on 15/11/5.
//  Copyright © 2015年 Mamahao. All rights reserved.
//

import Foundation


@objc(MMHSearchingSuggestedKeywordsManagerDelegate)
protocol SearchingSuggestedKeywordsManagerDelegate: NSObjectProtocol {
    func searchingSuggestedKeywordsManager(searchingSuggestedKeywordsManager: SearchingSuggestedKeywordsManager, suggestedKeywordsFetched suggestedKeywords: [String], forKeyword keyword: String)
}


@objc(MMHSearchingSuggestedKeywordsManager)
class SearchingSuggestedKeywordsManager: NSObject {
    
    weak var delegate: SearchingSuggestedKeywordsManagerDelegate?
    
    private var suggestedKeywords: [String: [String]] = [String: [String]]()
    private var fetchingKeywords: [String] = [String]()
    
    internal class var sharedManager: SearchingSuggestedKeywordsManager {
        struct Singleton {
            static let sharedManager = SearchingSuggestedKeywordsManager()
        }
        
        return Singleton.sharedManager
    }
    
    
    func tryToFetchSuggestedKeywordsForKeyword(keyword: String) {
        if self.fetchingKeywords.contains(keyword) {
            return
        }
        
        self.fetchingKeywords.append(keyword)
//        MMHNetworkAdapter.sharedAdapter().fetchSuggestedKeywordForKeyword(keyword, from: self, succeededHandler: { (fetchedKeywords: [String]!) -> Void in
//            self.suggestedKeywords[keyword] = fetchedKeywords
//            self.delegate?.searchingSuggestedKeywordsManager(self, suggestedKeywordsFetched: fetchedKeywords, forKeyword: keyword)
//            }) { (error: NSError!) -> Void in
//                
//        }
    }
}


// MARK: - API


extension SearchingSuggestedKeywordsManager {
    
    func suggestedKeywordsForKeyword(keyword: String) -> [String] {
        if keyword.characters.count == 0 {
            return [String]()
        }
        
        let keywords = self.suggestedKeywords[keyword]
        if keywords == nil {
            self.tryToFetchSuggestedKeywordsForKeyword(keyword)
            return [String]()
        }
        return keywords!
    }
    
}


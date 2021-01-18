//
//  SearchViewWorker.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import Foundation

class SearchViewWorker {
    
    /// get data for showing wikipedia search page
    func loadSearchViewInfo(pageId: Int, success: @escaping (SearchViewResponse) -> Void, failure: @escaping (Error) -> Void) {
        let apiendPoint  = URLManager.sharedInstance.getApiURLForType(apiType: .searchResults)
        guard var urlComponents = URLComponents(string: apiendPoint) else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "prop", value: "info"),
            URLQueryItem(name: "pageids", value: "\(pageId)"),
            URLQueryItem(name: "inprop", value: "url"),
            URLQueryItem(name: "format", value: "json")
        ]
        guard let urlString = urlComponents.url?.absoluteString else {
            return
        }
        NetworkManager.sharedInstance.cancelPreviousRequest()
        NetworkManager.sharedInstance.request(url: urlString, success: success, failure: failure)
    }
}

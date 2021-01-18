//
//  SearchAPIWorker.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import Foundation

class SearchAPIWorker {
    
    /// get data for showing wikipedia search results
    func loadSearchResultsInfo(body: String, productCount: String, success: @escaping (SearchResponse) -> Void, failure: @escaping (Error) -> Void) {
        let apiendPoint  = URLManager.sharedInstance.getApiURLForType(apiType: .searchResults)
        guard var urlComponents = URLComponents(string: apiendPoint) else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "prop", value: "pageimages|pageterms"),
            URLQueryItem(name: "generator", value: "prefixsearch"),
            URLQueryItem(name: "redirects", value: "1"),
            URLQueryItem(name: "formatversion", value: "2"),
            URLQueryItem(name: "piprop", value: "thumbnail"),
            URLQueryItem(name: "pithumbsize", value: "50"),
            URLQueryItem(name: "pilimit", value: "10"),
            URLQueryItem(name: "wbptterms", value: "description"),
            URLQueryItem(name: "gpssearch", value: body),
            URLQueryItem(name: "gpslimit", value: productCount)
        ]
        guard let urlString = urlComponents.url?.absoluteString else {
            return
        }
        NetworkManager.sharedInstance.cancelPreviousRequest()
        NetworkManager.sharedInstance.request(url: urlString, success: success, failure: failure)
    }
}

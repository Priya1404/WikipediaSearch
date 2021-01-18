//
//  SearchViewResponse.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import Foundation

class SearchViewResponse : Codable{
    let batchcomplete: String?
    let query: PageDetail?
}

class PageDetail: Codable {
    let pages: [String: Page]
}

class Page: Codable {
    let pageid: Int?
    let ns: Int?
    let title: String?
    let contentmodel: String?
    let pagelanguage: String?
    let pagelanguagehtmlcode: String?
    let pagelanguagedir: String?
    let touched: String?
    let lastrevid: Int?
    let length: Int?
    let fullurl: String?
    let editurl: String?
    let canonicalurl: String?
}

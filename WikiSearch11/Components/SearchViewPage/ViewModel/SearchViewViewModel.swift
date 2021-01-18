//
//  SearchViewViewModel.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import Foundation
import UIKit

class SearchViewViewModel {
    
    //MARK:- Properties
    var dataSource: Page?
    
    ///set data source
    func setDataSource(response viewResponse: SearchViewResponse, pageId: Int) {
        self.dataSource = viewResponse.query?.pages[String(pageId)]
    }
    
    ///get search url from data source
    func getSearchURL() -> String {
        if let dataSource = dataSource, let url = dataSource.fullurl {
            return url
        }
        return ""
    }
}

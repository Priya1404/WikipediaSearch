//
//  SearchListViewModel.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import Foundation
import UIKit

//Enum for dictionary keys for retrieving the data
enum DetailKeys: String {
    case title
    case description
    case image
    case imageWidth
    case imageHeight
}

class SearchListViewModel {
    
    //MARK:- PageConstants
    struct PageConstants {
        static let rowHeight = 85
    }
    
    //MARK:- Properties
    var dataSource: [Pages]?
    
    /// set data source from response
    func setDataSource(response searchResponse: SearchResponse){
        self.dataSource = searchResponse.query?.pages
    }
    
    //MARK:- Tableview method calls
    //get number of rows
    func getNumberOfRows() -> Int {
        if let dataSource = dataSource {
            return dataSource.count
        }
        return 0
    }
    
    ///get title text
    func getRowTitle(forRow row: Int) -> String {
        if let dataSource = dataSource, let title = dataSource[row].title {
            return title
        }
        return ""
    }
    
    ///get fixed row Height for tableview
    func getCellHeight() -> CGFloat {
        return CGFloat(PageConstants.rowHeight)
    }
    
    ///get Cell details
    func getDetails(forRow row: Int) -> [String: AnyObject]{
        var details = [String: AnyObject]()
        if let dataSource = dataSource {
            details[DetailKeys.title.rawValue] = dataSource[row].title  as AnyObject?
            if let descriptionText = dataSource[row].terms?.description {
                details[DetailKeys.description.rawValue] = descriptionText[0] as AnyObject
            }
            if let thumbnailSource = dataSource[row].thumbnail?.source {
                details[DetailKeys.image.rawValue] = thumbnailSource as AnyObject
            }
            if let thumbnailWidth = dataSource[row].thumbnail?.width {
                details[DetailKeys.imageWidth.rawValue] = CGFloat(thumbnailWidth) as AnyObject
            }
            if let thumbnailHeight = dataSource[row].thumbnail?.height {
                details[DetailKeys.imageHeight.rawValue] = CGFloat(thumbnailHeight) as AnyObject
            }
            return details
        }
        return [:]
    }
    
    //MARK:- Data required to move to next screen
    ///get pageId
    func getPageId(forRow row: Int) -> Int {
        if let dataSource = dataSource, let pageId = dataSource[row].pageid {
            return pageId
        }
        return 0
    }
}

//
//  Caching.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import Foundation
import UIKit

let imageCache = ImageCache()

/// Utility class for caching image
class ImageCache: NSCache<AnyObject, AnyObject> {
    
    ///Add new downloaded image
    func addImage(_ image: UIImage, key: String) {
        setObject(image, forKey: key as AnyObject)
    }
    
    ///Get image if already present
    func getImage(forKey key: String) -> UIImage? {
        guard let image = object(forKey: key as AnyObject) as? UIImage else {
            return nil
        }
        return image
    }
}

//
//  WikiSearch+Extensions.swift
//  WikiSearch11
//
//  Created by Priya Srivastava on 18/01/21.
//  Copyright © 2021 Priya Srivastava. All rights reserved.
//

import Foundation
import  UIKit

//MARK:- UIView extension
extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    /// Used to show a loader
    ///
    /// - Parameters:
    ///   - activityIndicatorStyle: style
    ///   - onTopOf:
    ///   - color:
    ///   - withYOffest:
    
    func showLoader(_ activityIndicatorStyle: UIActivityIndicatorView.Style = IS_IPAD ? .large : .medium, onTopOf : UIView? = nil,color : UIColor? = .brown ,withYOffest : CGFloat = IS_IPAD ? 0 : -24){
        var frameView = self
        if let onTopOf = onTopOf{
            frameView = onTopOf
        }
        if self.viewWithTag(12345) == nil{
            //Make sure multiple activityIndicators are not added to the same view
            self.isUserInteractionEnabled = false
            let activityIndicator = UIActivityIndicatorView(style: activityIndicatorStyle)
            activityIndicator.tag = 12345
            activityIndicator.frame = CGRect(x: frameView.frame.origin.x + frameView.frame.size.width/2 - 13,y: frameView.frame.origin.y +  frameView.frame.size.height/2 - 13 + withYOffest, width: 26, height: 26)
            self.addSubview(activityIndicator)
            activityIndicator.color = color
            activityIndicator.startAnimating()
        }
    }
    
    func dismissloader(){
        self.isUserInteractionEnabled = true
        if let  activityIndicator = self.viewWithTag(12345) as? UIActivityIndicatorView{
            activityIndicator.removeFromSuperview()
        }
    }
}

//MARK:- UIViewController extension
extension UIViewController{
    
    class func getViewControllerWith(storyBoardID : String , ViewControllerID : String) -> UIViewController{
        let storyboard = UIStoryboard(name: storyBoardID, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerID)
    }
}

private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

//MARK:- UIColor extension

/// An extension of UIColor (on iOS) or NSColor (on OSX) providing HEX color handling.
public extension UIColor {
    /**
     Create non-autoreleased color with in the given hex string. Alpha will be set as 1 by default.
     - parameter hexString: The hex string, with or without the hash character.
     - returns: A color with the given hex string.
     */
    convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    private convenience init?(hex3: Int, alpha: Float) {
        self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                  alpha: CGFloat(alpha))
    }
    
    private convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }
    
    /**
     Create non-autoreleased color with in the given hex string and alpha.
     
     - parameter hexString: The hex string, with or without the hash character.
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: A color with the given hex string and alpha.
     */
    convenience init?(hexString: String, alpha: Float) {
        var hex = hexString
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }
        guard let hexVal = Int(hex, radix: 16) else {
            self.init()
            return nil
        }
        switch hex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        default:
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }
}

//MARK:- UIAlertController extension
///Extension for personalized features in alertcontroller
extension UIAlertController {
    @discardableResult
    public class func showAlert(in vc: UIViewController, title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        vc.present(alertController, animated: true, completion: nil)
        return alertController
    }
}

//MARK:- UIImageView extension

///Extension to directly downlaod image and show in imageView
extension UIImageView {
    func setImage(fromUrl url: String?, contentMode mode: UIView.ContentMode = .scaleToFill) {
        contentMode = mode
        self.image = UIImage(named: "")
        if let url = url {
            ImageDownloader.sharedInstance.getImage(fromUrl: url) { (image) in
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

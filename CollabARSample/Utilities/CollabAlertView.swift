//
//  CollabAlertView.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 01/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import Foundation
import UIKit
enum AlertAction{
    case Ok
    case Cancel
}


typealias AlertCompletionHandler = ((_ index:AlertAction)->())?
typealias AlertCompletionHandlerInt = ((_ index:Int)->())

class CollabAlertView:UIViewController{
    
    
    class func showAlert(title:String?, message:String?, topViewcontroller:UIViewController){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:.default, handler:nil))
        topViewcontroller.present(alert, animated: true)
    }
    
    class func showAlertWithHandler(title:String?, message:String?, topViewcontroller:UIViewController, handler:AlertCompletionHandler){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:"Ok", style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel", style:.default, handler: { (alert) in
            handler?(AlertAction.Cancel)
        }))
        topViewcontroller.present(alert, animated: true)
    }
    
    class func showAlertWithHandler(title:String?, message:String?, okButtonTitle:String, cancelButtionTitle:String, topViewcontroller:UIViewController, handler:AlertCompletionHandler){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:okButtonTitle, style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        
        alert.addAction(UIAlertAction(title:cancelButtionTitle, style:.default, handler: { (alert) in
            handler?(AlertAction.Cancel)
        }))
        
        topViewcontroller.present(alert, animated: true)
    }
    
    
    class func showAlertWithHandler(title:String?, message:String?, buttonsTitles:[String], showAsActionSheet: Bool,  topViewcontroller:UIViewController, handler:@escaping AlertCompletionHandlerInt){
        
        let alert = UIAlertController(title:title, message: message, preferredStyle: (showAsActionSheet ?.actionSheet : .alert))
        
        for btnTitle in buttonsTitles{
            alert.addAction(UIAlertAction(title:btnTitle, style:.default, handler: { (alert) in
                handler(buttonsTitles.firstIndex(of: btnTitle)!)
            }))
        }
        
        topViewcontroller.present(alert, animated: true)
    }
}

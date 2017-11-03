//
//  Interface.swift
//  SaitamaCycles
//
//  Created by Best Peers on 16/10/17.
//  Copyright © 2017 www.Zoeb.SaitamaCycles. All rights reserved.
//

import UIKit

class Interface: NSObject {
    
    var interfaceBlock:CompletionHandler?
    
    func validateResponse(status:Bool, response:AnyObject) ->Bool
    {
        guard response is Dictionary<String, AnyObject> else {
            
            var errorMessage:String = Constants.kErrorMessage
            if response is NSError{
                errorMessage = ((response as? NSError)?.localizedDescription)!
            }
            
            interfaceBlock!(false, errorMessage)
            BannerManager.showFailureBanner(subtitle: errorMessage)
            
            return false
        }
        
        if !status {
            let responseDict = response as! Dictionary<String, Any>
            
            var message  = Constants.kErrorMessage
            
            if let code:Int = responseDict["code"] as? Int{
              
                switch code{
                case 1002:
                    message = "Place not found"
                case 401:
                    message = "User is not authorized"
                case 1001:
                    message = "Sorry, we don't recognise this user"
                case 1000:
                    message = "A Saitama account already exists with this email address"
                default:
                    message = Constants.kErrorMessage
                }
            }
            
            interfaceBlock!(false, message)
            BannerManager.showFailureBanner(subtitle: message)
            return false
        }
        
        return true
    }
}

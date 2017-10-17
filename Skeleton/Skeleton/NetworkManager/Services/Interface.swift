//
//  Interface.swift
//  Skeleton
//
//  Created by Best Peers on 16/10/17.
//  Copyright © 2017 www.BestPeers.Skeleton. All rights reserved.
//

import UIKit

class Interface: NSObject {
    
    var interfaceBlock:CompletionHandler?
    
    func validateResponse(response:AnyObject) ->Bool
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
        
        return true
    }
}

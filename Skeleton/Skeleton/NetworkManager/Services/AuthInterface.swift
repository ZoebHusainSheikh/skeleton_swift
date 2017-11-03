//
//  AuthInterface.swift
//  SaitamaCycles
//
//  Created by Best Peers on 03/11/17.
//  Copyright © 2017 www.Systango.Skeleton. All rights reserved.
//

import UIKit

class AuthInterface: Interface {
    
    public func performLogin(request: AuthRequest, completion: @escaping CompletionHandler) {
        interfaceBlock = completion
        RealAPI().postObject(request: request) { (success, response) in
            self.parseSuccessResponse(status:success, response:response as AnyObject)
        }
    }
    
    public func performSignup(request: AuthRequest, completion: @escaping CompletionHandler) {
        interfaceBlock = completion
        RealAPI().putObject(request: request) { (success, response) in
            self.parseSuccessResponse(status:success, response:response as AnyObject)
        }
    }
    
    // MARK: Parse Response
    
    func parseSuccessResponse(status:Bool, response: AnyObject?) -> Void {
        if validateResponse(status:status, response: response!){
            let responseDict = response as! Dictionary<String, Any>
            
            let token:String? = responseDict["token"] as? String
            if token != nil && (token!.length > 0) {
                
                // store token in user defaults
                UserDefaults.standard.set(token, forKey: Constants.kSessionKey)
            }
            interfaceBlock!(status, token)
        }
    }

}

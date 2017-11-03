//
//  RequestManager.swift
//  SaitamaCycles
//
//  Created by Zoeb on 05/06/17.
//  Copyright © 2017 Zoeb . All rights reserved.
//

import UIKit

class RequestManager: NSObject {
    
    //MARK: Authentication API
    
    func performLogin(email:String, password:String, completion:@escaping CompletionHandler){
        performAuthentication(email: email, password: password, authType: .LoginType, completion: completion)
    }
    
    func performSignup(email:String, password:String, completion:@escaping CompletionHandler){
        performAuthentication(email: email, password: password, authType: .SignupType, completion: completion)
    }
    
    func performAuthentication(email:String, password:String, authType: AuthType, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            if authType.isLoginViewActivated() {
                AuthInterface().performLogin(request: AuthRequest().initwithRequest(email: email, password: password), completion: completion)
            }
            else{
                AuthInterface().performSignup(request: AuthRequest().initwithRequest(email: email, password: password), completion: completion)
            }
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
}

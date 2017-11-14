//
//  RequestManager.swift
//  SaitamaCycles
//
//  Created by Nilesh K on 05/06/17.
//  Copyright © 2017. All rights reserved.
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
                Interface().performLogin(request: Request().initwithAuthRequest(email: email, password: password), completion: completion)
            }
            else{
                Interface().performSignup(request: Request().initwithAuthRequest(email: email, password: password), completion: completion)
            }
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    //MARK: Payment Creation API
    
    func performPaymentCreation(placeId:String, creditCard:CreditCardModel, completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            Interface().paymentCreation(request: Request().initwithPaymentCreationRequest(placeId: placeId, creditCard: creditCard), completion: completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    //MARK: Payment List API
    
    func getPaymentList(completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            Interface().paymentList(request: Request().initwithPaymentListRequest(), completion: completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
    
    //MARK: Place List API
    
    func getPlaceList(completion:@escaping CompletionHandler){
        if ApplicationDelegate.isNetworkAvailable{
            Interface().getPlaceList(request: Request().initwithPlacesRequest(), completion: completion)
        }
        else{
            completion(false, Constants.kNoNetworkMessage)
            BannerManager.showFailureBanner(subtitle: Constants.kNoNetworkMessage)
        }
    }
}

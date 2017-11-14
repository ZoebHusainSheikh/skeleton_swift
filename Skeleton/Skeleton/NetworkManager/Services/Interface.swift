//
//  Interface.swift
//  SaitamaCycles
//
//  Created by Nilesh K on 16/10/17.
//  Copyright © 2017 www.Nilesh K.SaitamaCycles. All rights reserved.
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
    
    public func performLogin(request: Request, completion: @escaping CompletionHandler) {
        interfaceBlock = completion
        RealAPI().postObject(request: request) { (success, response) in
            self.parseSuccessResponse(status:success, response:response as AnyObject)
        }
    }
    
    public func performSignup(request: Request, completion: @escaping CompletionHandler) {
        interfaceBlock = completion
        RealAPI().putObject(request: request) { (success, response) in
            self.parseSuccessResponse(status:success, response:response as AnyObject)
        }
    }
    
    public func paymentCreation(request: Request, completion: @escaping CompletionHandler) {
        interfaceBlock = completion
        RealAPI().putObject(request: request) { (success, response) in
            self.parsePaymentCreationSuccessResponse(status:success, response:response as AnyObject)
        }
    }
    
    public func paymentList(request: Request, completion: @escaping CompletionHandler) {
        interfaceBlock = completion
        RealAPI().getObject(request: request) { (success, response) in
            self.parseSuccessResponse(status:success, response:response as AnyObject)
        }
    }
    
    public func getPlaceList(request: Request, completion: @escaping CompletionHandler) {
        interfaceBlock = completion
        RealAPI().getObject(request: request) { (success, response) in
            self.parseGetPlacesSuccessResponse(status:success, response:response as AnyObject)
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
    
    func parseGetPlacesSuccessResponse(status:Bool, response: AnyObject?) -> Void {
        if validateResponse(status:status, response: response!){
            let responseDict = response as! Dictionary<String, Any>
            var placeList:Array<PlaceModel> = []
            if let places = responseDict["places"] as? Array<Dictionary<String, AnyObject>>{
                for place in places {
                    print(place)
                    let placeObj:PlaceModel = PlaceModel(updatedAt: place["updatedAt"] as! String, createdAt: place["createdAt"] as! String, id: place["id"] as! String, name: place["name"] as! String, location: place["location"] as! Dictionary<String, String>)
                    placeList.append(placeObj)
                }
            }
            interfaceBlock!(status, placeList)
        }
    }
    
    func parsePaymentCreationSuccessResponse(status:Bool, response: AnyObject?) -> Void {
        if validateResponse(status:status, response: response!){
            interfaceBlock!(status, response)
        }
    }
}

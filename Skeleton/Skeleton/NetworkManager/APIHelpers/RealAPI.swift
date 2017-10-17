//
//  RealAPI.swift
//  Skeleton
//
//  Created by BestPeers on 01/06/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit
import SMobiLog
import Alamofire

class RealAPI: NSObject, APIInteractor {
    
    var VMRequest: Request = Request()
    var isForbiddenRetry: Bool = false
    var realAPIBlock: CompletionHandler = { _,_ in }
    
    func putObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithPutObject(request: request, completion: completion)
    }
    
    func getObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithGetObject(request: request, completion: completion)
    }
    
    func postObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithPostObject(request: request, completion: completion)
    }
    
    func deleteObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithDeleteObject(request: request, completion: completion)
    }
    
    func multiPartObjectPost(request: Request, completion: @escaping CompletionHandler) -> Void {
        interactAPIWithMultipartObjectPost(request: request, completion: completion)
    }
    
    // MARK: Request methods
    func interactAPIWithGetObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.GET.rawValue)
        NetworkHttpClient.sharedInstance.getAPICall(request.urlPath, parameters: request.getParams(), success: { (responseObject) in
            self.handleSuccessResponse(response: responseObject, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject, block: completion)
        })
    }
    
    func interactAPIWithPutObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.PUT.rawValue)
        NetworkHttpClient.sharedInstance.putAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, success: { (responseObject) in
            self.handleSuccessResponse(response: responseObject, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject, block: completion)
        })
    }
    
    func interactAPIWithPostObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.POST.rawValue)
        NetworkHttpClient.sharedInstance.postAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, success: { (responseObject) in
            self.handleSuccessResponse(response: responseObject, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject, block: completion)
        })
    }
    
    func interactAPIWithDeleteObject(request: Request, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.DELETE.rawValue)
        NetworkHttpClient.sharedInstance.deleteAPICall(request.urlPath, parameters: request.getParams(), headers: request.headers, success: { (responseObject) in
            self.handleSuccessResponse(response: responseObject, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject, block: completion)
        })
    }
    
    func interactAPIWithMultipartObjectPost(request: Request, completion: @escaping CompletionHandler) -> Void {
        initialSetup(request: request, requestType: Constants.RequestType.MultiPartPost.rawValue)
        NetworkHttpClient.sharedInstance.multipartPostAPICall(request.urlPath, parameters: request.getParams(), data: request.fileData, name: request.dataFilename, fileName: request.fileName, mimeType: request.mimeType, success: { (responseObject) in
            self.handleSuccessResponse(response: responseObject, block: completion)
        }, failure: { (responseObject) in
            self.handleError(response: responseObject, block: completion)
        })
    }
    
    //Handling success response
    func handleSuccessResponse(response: Any?, block:CompletionHandler) -> Void {
        
        let responseStatus = (response as! DataResponse<Any>).response
        let message: String = String.init(format: "Success:- URL:%@\n", (responseStatus?.url?.absoluteString)!)
        print(message)
        
        if responseStatus?.statusCode == Constants.ResponseStatusSuccess || responseStatus?.statusCode == Constants.ResponseStatusCreated {
            if response != nil {
                isForbiddenRetry = false
                if let result = (response as! DataResponse<Any>).result.value {
                    let JSON = result as! NSDictionary
                    print(JSON)
                    block(true, JSON)
                }
                return
            }
        }
        
        block(false, nil)
    }
    
    //Handling Error response
    func handleError(response: Any?, block: @escaping CompletionHandler) -> Void {
        let responseStatus = (response as! DataResponse<Any>).response
        
        if self.isForbiddenResponse(statusCode: (responseStatus?.statusCode)!) {
            realAPIBlock = block
            renewLogin()
            return
        }
        
        var errorResponse: Any?
        
        let error : Error? = (response as! DataResponse<Any>).result.error!
        
        let detailedError: NSError = error as! NSError
        if detailedError.localizedRecoverySuggestion != nil {
            do {
                errorResponse = try JSONSerialization.jsonObject(with: (detailedError.localizedRecoverySuggestion?.data(using: String.Encoding.utf8))!, options: JSONSerialization.ReadingOptions.mutableContainers)
                let message: String = String.init(format: "\n Error :Failure with error: %@", detailedError.localizedRecoverySuggestion!)
                SMobiLogger.sharedInterface().error(String.init(format: "%s", #function), withDescription: message)
                errorResponse != nil ? block(false, errorResponse) : block(false, error)
            }
            catch _ {
                // Error handling
            }
        }
        /*else if error?.localizedDescription != nil {
            var message: String = String.init(format: "\n Error :Failure with error: %@", error!.localizedDescription)
            SMobiLogger.sharedInterface().error(String.init(format: "%s", #function), withDescription: message)
            
            let errorData: Data? = detailedError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
            var serializedData: Any?
            if errorData != nil {
                do {
                    serializedData = try JSONSerialization.jsonObject(with: errorData!)
                    if serializedData is Dictionary<String, Any> {
                        //Banner.showFailure(subtitle: serializedData["error"])
                    }
                }
                catch _ {
                    // Error handling
                }
            } else {
                serializedData = ["message": error?.localizedDescription]
                //Banner.showFailure(subtitle: error?.localizedDescription)
            }
            
            message = String.init(format: "Failure error serialised - %@",serializedData as! CVarArg)
            
            if serializedData == nil {
                serializedData = ["message": "An error occured while processing your request."]
                //Banner.showFailure(subtitle:"An error occured while processing your request.")
            }
            
            if responseStatus?.statusCode == Constants.ResponseStatusForbidden {
                // *> Show Alert
                //ApplicationDelegate.showAlert(message: "Your session expired", logout: true)
            }
            block(false, serializedData)
        }*/
        
        else {
            block(false, detailedError.description)
        }
    }
    
    func initialSetup(request: Request, requestType: NSInteger) -> Void {
        VMRequest = request
        VMRequest.requestType = requestType
        let message: String = String.init(format: "Info: Performing API call with [URL:%@] [params: %@]", request.urlPath, request.getParams())
        print(message)
    }
    
    func isForbiddenResponse(statusCode: NSInteger) -> Bool {
        if statusCode == Constants.ResponseStatusForbidden && isForbiddenRetry == false {
            isForbiddenRetry = true
            return true
        }
        return false
    }
    
    func renewLogin() -> Void {
        //User.sharedUser.resetSharedInstance()
        
        // login with saved values
        self.loginWithSavedValues()
    }
    
    func loginWithSavedValues() {
//        let userAuth: UserAuth? = UserAuth.getSavedAuth()
//        if userAuth {
//            if (userAuth.facebookId != nil && userAuth.facebookId.length) || (userAuth.password != nil && userAuth.password.length && userAuth.email != nil && userAuth.email.length) {
//                RequestManager.login(userAuth: userAuth, completion: { (success, response) in
//                    if success {
//                        User.sharedUser.saveLoggedinUserInfoInUserDefault()
//                        
//                        // Trigger last saved API call
//                        self.renewLoginRequestCompleted()
//                    } else {
//                        realAPIBlock(false, nil)
//                    }
//                })
//                return
//            }
//        }
//        realAPIBlock(false, nil)
//        
//        //*> Show Alert
//        ApplicationDelegate.showAlert(message:"Your session expire", isLogout:YES);
    }
    
//    func renewLoginRequestCompleted() {
//        // calling failed API again
//        switch VMRequest.requestType {
//        case Constants.RequestType.GET.rawValue:
//            self.interactAPIWithGetObject(request: VMRequest, completion: realAPIBlock)
//            break
//        case Constants.RequestType.POST.rawValue:
//            self.interactAPIWithPostObject(request: VMRequest, completion: realAPIBlock)
//            break
//        case Constants.RequestType.PUT.rawValue:
//            self.interactAPIWithPutObject(request: VMRequest, completion: realAPIBlock)
//            break
//        case Constants.RequestType.MultiPartPost.rawValue:
//            self.interactAPIWithMultipartObjectPost(request: VMRequest, completion: realAPIBlock)
//            break
//        case Constants.RequestType.DELETE.rawValue:
//            self.interactAPIWithDeleteObject(request: VMRequest, completion: realAPIBlock)
//            break
//        default:
//            break
//        }
//    }
}

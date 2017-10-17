//
//  NetworkHttpClient.swift
//  Skeleton
//
//  Created by BestPeers on 31/05/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkHttpClient: NSObject {
    
    typealias successBlock = (_ response: Any?) -> Void
    typealias failureBlock = (_ response: Any?) -> Void
    
    static let sharedInstance = NetworkHttpClient()
    
    var urlPathSubstring: String = ""
    
    override init() {
        let appSettings: AppSettings = AppSettingsManager.sharedInstance.fetchSettings()
        urlPathSubstring = appSettings.URLPathSubstring
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: BASE URL
    class func baseUrl() -> String {
        let appSettings: AppSettings = AppSettingsManager.sharedInstance.appSettings
        
        let secureConnection: String = appSettings.EnableSecureConnection ? Constants.SecureProtocol : Constants.InsecureProtocol
        if appSettings.NetworkMode == Constants.LiveEnviroment { // for live env
            return String.init(format: "%@%@", secureConnection, appSettings.ProductionURL)
        } else if appSettings.NetworkMode == Constants.StagingEnviroment { // for staging env
            return String.init(format: "%@%@", secureConnection, appSettings.StagingURL)
        } else // for local env
        {
            return String.init(format: "%@%@", secureConnection, appSettings.LocalURL)
        }
    }
    
    // MARK: API calls
    func getAPICall(_ strURL : String, parameters : Dictionary<String, Any>?, success:@escaping successBlock, failure:@escaping failureBlock) {
//        var headers:HTTPHeaders = [String:String]()
//        headers["X-Mashape-Key"] = "gffsVZi52omsh52gxrT335Shh8aNp128WjajsnahxEMl6530yo"
        let headers:HTTPHeaders = ["X-Mashape-Key": "gffsVZi52omsh52gxrT335Shh8aNp128WjajsnahxEMl6530yo", "Accept": "application/json"];

        
        
        performAPICall(strURL, methodType: .get, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    func putAPICall(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, success:@escaping successBlock, failure:@escaping failureBlock) {
        
        performAPICall(strURL, methodType: .put, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    func postAPICall(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, success:@escaping successBlock, failure:@escaping failureBlock) {
        
        performAPICall(strURL, methodType: .post, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    func deleteAPICall(_ strURL : String, parameters : Dictionary<String, Any>?, headers : [String : String]?, success:@escaping successBlock, failure:@escaping failureBlock) {
        
        performAPICall(strURL, methodType: .delete, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    func performAPICall(_ strURL : String, methodType: HTTPMethod, parameters : Dictionary<String, Any>?, headers : [String : String]?, success:@escaping successBlock, failure:@escaping failureBlock){
        
        let completeURL:String = NetworkHttpClient.baseUrl() + strURL
        
        Alamofire.request(completeURL, method: methodType, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
//                let resJson = JSON(responseObject.result.value!)
                success(responseObject)
            }
            if responseObject.result.isFailure {
//                let error : Error = responseObject.result.error!
                failure(responseObject)
            }
        }
    }
    
    func multipartPostAPICall(_ strURL: String, parameters: Dictionary<String, Any>?, data: Data, name: String, fileName: String, mimeType: String, success: @escaping successBlock, failure: @escaping failureBlock) -> Void{
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
        }, to: strURL, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    success(response)
                }
            case .failure(let encodingError):
                failure(encodingError)
            }
        })
    }
}

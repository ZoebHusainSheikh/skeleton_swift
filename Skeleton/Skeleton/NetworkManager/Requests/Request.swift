//
//  Request.swift
//  SaitamaCycles
//
//  Created by Nilesh K on 29/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Alamofire

class Request: NSObject {

    var urlPath: String
    var requestType: NSInteger
    var fileData: Data
    var dataFilename: String
    var fileName: String
    var mimeType: String
    var headers: [String: String]?
    var parameters: Dictionary<String, Any>
    
    
    let authUrl = "users/"
    let paymentCreationUrl = "payments/"
    let placesUrl = "places/"
    
    override init() {
        urlPath = ""
        requestType = 0
        fileData = Data()
        dataFilename = ""
        fileName = ""
        mimeType = ""
        parameters = [:]
        super.init()
    }
    
    public func getParams() -> Dictionary<String, Any> {
        return parameters
    }
    
    public class func getUrl(path: String) -> String {
        let client: NetworkHttpClient = NetworkHttpClient.sharedInstance
        return String.init(format: "%@%@",client.urlPathSubstring, path)
    }
    
    func initwithAuthRequest(email:String, password:String) -> Request{
        parameters["email"] = email
        parameters["password"] = password
        urlPath = authUrl
        return self
    }
    
    func initwithPaymentCreationRequest(placeId:String, creditCard:CreditCardModel) -> Request{
        parameters["placeId"] = placeId
        parameters["number"] = creditCard.number
        parameters["name"] = creditCard.name
        parameters["expiryMonth"] = creditCard.expiryMonth
        parameters["expiryYear"] = creditCard.expiryYear
        parameters["cvv"] = creditCard.cvv
        urlPath = paymentCreationUrl
        headers = NetworkHttpClient.getHeader() as! HTTPHeaders
        return self
    }
    
    func initwithPaymentListRequest() -> Request{
        urlPath = paymentCreationUrl
        headers = NetworkHttpClient.getHeader() as! HTTPHeaders
        return self
    }
    
    func initwithPlacesRequest() -> Request{
        urlPath = placesUrl
        return self
    }
}

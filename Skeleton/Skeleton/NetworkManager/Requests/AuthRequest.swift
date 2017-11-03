//
//  AuthRequest.swift
//  SaitamaCycles
//
//  Created by Best Peers on 03/11/17.
//  Copyright © 2017 www.Systango.Skeleton. All rights reserved.
//

import UIKit

let authUrl = "/users/"

class AuthRequest: Request {
    
    func initwithRequest(email:String, password:String) -> AuthRequest{
        parameters["email"] = email
        parameters["password"] = password
        urlPath = authUrl
        return self
    }

}

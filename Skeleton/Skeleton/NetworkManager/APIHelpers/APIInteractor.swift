//
//  APIInteractor.swift
//  Skeleton
//
//  Created by BestPeers on 29/05/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit

protocol APIInteractor: class {
    
    func putObject(request: Request, completion: @escaping CompletionHandler) -> Void
    
    func getObject(request: Request, completion: @escaping CompletionHandler) -> Void
    
    func postObject(request: Request, completion: @escaping CompletionHandler) -> Void
    
    func deleteObject(request: Request, completion: @escaping CompletionHandler) -> Void
    
    func multiPartObjectPost(request: Request, completion: @escaping CompletionHandler) -> Void
    
}

//
//  WordRequest.swift
//  Skeleton
//
//  Created by Best Peers on 16/10/17.
//  Copyright © 2017 www.BestPeers.Skeleton. All rights reserved.
//

import UIKit

class WordRequest: Request {
    
    var wordInfoType:WordInfoType!
    
    func initWordRequest(word:String, wordInfoType:WordInfoType) -> WordRequest{
        self.wordInfoType = wordInfoType
        urlPath = word + "/" + wordInfoType.getString()
        
        return self
    }

}

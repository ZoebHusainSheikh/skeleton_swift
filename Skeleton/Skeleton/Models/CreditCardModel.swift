//
//  CreditCardModel.swift
//  SaitamaCycles
//
//  Created by Nilesh K Sheikh on 04/11/17.
//  Copyright © 2017 www.Systango.Skeleton. All rights reserved.
//

import UIKit

class CreditCardModel: NSObject {
    var number: String?
    var name: String?
    var cvv: String?
    var expiryMonth: String?
    var expiryYear: String?
    
    init(number:String, name:String, cvv:String, expiryMonth:String, expiryYear:String) {
        self.number = number
        self.name = name
        self.cvv = cvv
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
    }
}

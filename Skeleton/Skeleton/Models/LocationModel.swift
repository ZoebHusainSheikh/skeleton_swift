//
//  LocationModel.swift
//  SaitamaCycles
//
//  Created by Nilesh K Sheikh on 04/11/17.
//  Copyright © 2017 www.Systango.Skeleton. All rights reserved.
//

import UIKit

class LocationModel: NSObject {
    var latitude:String?
    var longitude:String?
    
    init(latitude:String, longitude:String) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

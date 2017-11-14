//
//  PlaceModel.swift
//  SaitamaCycles
//
//  Created by Nilesh K Sheikh on 04/11/17.
//  Copyright © 2017 www.Systango.Skeleton. All rights reserved.
//

import UIKit

class PlaceModel: NSObject {
    var updatedAt:String?
    var createdAt:String?
    var id:String?
    var name:String?
    var location:LocationModel?
    
    init(updatedAt:String, createdAt:String, id:String, name:String, location:Dictionary<String, String>) {
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.id = id
        self.name = name
        self.location = LocationModel(latitude: location["lat"] as! String, longitude: location["lng"] as! String)
    }
}

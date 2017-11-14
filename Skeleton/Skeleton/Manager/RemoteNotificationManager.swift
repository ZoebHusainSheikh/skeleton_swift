//
//  RemoteNotificationManager.swift
//  SaitamaCycles
//
//  Created by Nilesh K on 19/06/17.
//  Copyright © 2017 www.Nilesh K.SaitamaCycles. All rights reserved.
//

import UIKit

class RemoteNotificationManager: NSObject {
    var userConversationThreadId: NSNumber = NSNumber.init(value: 0)
    var postActivityId: NSNumber = NSNumber.init(value: 0)
    
    public func showAlertAfterRemoteNotification(userInfo: Dictionary<String, Any>) {
        
    }
    
    public func resetNotificationTray(block: () -> ()) {
        
    }
}

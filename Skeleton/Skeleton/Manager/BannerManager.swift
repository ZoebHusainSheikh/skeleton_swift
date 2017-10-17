//
//  BannerManager.swift
//  Skeleton
//
//  Created by Best Peers on 17/10/17.
//  Copyright © 2017 www.BestPeers.Skeleton. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class BannerManager: NSObject {
    
    static func showSuccessBanner(title:String = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String, subtitle:String){
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .success)
        banner.show()
    }
    
    static func showFailureBanner(title:String = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String, subtitle:String){
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .danger)
        banner.show()
    }

}

//
//  AppSettings.swift
//  Skeleton
//
//  Created by BestPeers on 01/06/17.
//  Copyright © 2017 BestPeers. All rights reserved.
//

import UIKit

class AppSettings: NSObject {
    var NetworkMode: String = ""
    var LocalURL: String = ""
    var ProductionURL: String = ""
    var StagingURL: String = ""
    var URLPathSubstring: String = ""
    var EnableSecureConnection: Bool = false
    var EnablePullToRefresh: Bool = false
    var EnableBanner: Bool = false
    var EnableCoreData: Bool = false
    var EnableTwitter: Bool = false
    var EnableFacebook: Bool = false
    
    static func appSettingsFromDict(dict:NSDictionary) -> AppSettings{
        let appSettings:AppSettings = AppSettings()
        appSettings.NetworkMode = dict["NetworkMode"] as! String
        appSettings.LocalURL = dict["LocalURL"] as! String
        appSettings.ProductionURL = dict["ProductionURL"] as! String
        appSettings.StagingURL = dict["StagingURL"] as! String
        appSettings.URLPathSubstring = dict["URLPathSubstring"] as! String
        appSettings.EnableSecureConnection = dict["EnableSecureConnection"] as! Bool
        appSettings.EnablePullToRefresh = dict["EnablePullToRefresh"] as! Bool
        appSettings.EnableBanner = dict["EnableBanner"] as! Bool
        appSettings.EnableCoreData = dict["EnableCoreData"] as! Bool
        appSettings.EnableTwitter = dict["EnableTwitter"] as! Bool
        appSettings.EnableFacebook = dict["EnableFacebook"] as! Bool
        
        return appSettings;
    }
}

//
//  Constants.swift
//  Bankable Solution
//
//  Created by Appster on 09/05/17.
//  Copyright © 2017 alm. All rights reserved.
//
//com.googleusercontent.apps.313192316404-ghum6vmr956psnjv486841c1ut1pbsvf gmail URL type
import Foundation
import UIKit

class Constants {
        
    public static let NetworkUnavailable = "Network unavailable. Please check your internet connectivity"
    
    public static let USERDEFAULTS = UserDefaults.standard
    public static var ROOTVIEW = UIApplication.shared.windows.filter {$0.isKeyWindow}.last?.rootViewController
    
    public static let DEVICE_TYPE = "iOS"
    
    public static let PRIVACY = "https://devjogisoftechwebpp.netlify.app/"
    public static let TERMS = "https://devjogisoftechwebtu.netlify.app/"

        
    public static let BANNER = "ca-app-pub-3940256099942544/2435281174"
    public static let INTERTIALS = "ca-app-pub-3940256099942544/6978759866"
    public static let OPEN = "ca-app-pub-3940256099942544/5662855259"
    
    public static let storyBoard = UIStoryboard(name: "Main", bundle:Bundle.main)
    public static let Home = UIStoryboard(name: "Home", bundle:Bundle.main)
        

}

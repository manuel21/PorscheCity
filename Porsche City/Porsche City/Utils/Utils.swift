//
//  Utils.swift
//  Porsche City
//
//  Created by Gerardo on 04/11/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit

class Utils: NSObject {

    class func isLandscape() -> Bool {
        return UIApplication.shared.statusBarOrientation == .landscapeRight || UIApplication.shared.statusBarOrientation == .landscapeLeft
        
//        UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
    }
    
    class func isPortrait() -> Bool {
        return UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown
        
        //return UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
    }
}

//
//  Storyboard.swift

import UIKit

class Storyboard: NSObject
{
    ///Get instance from Storyboard
    class func getInstanceOf<T: UIViewController>(_ type: T.Type) -> T
    {        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: "\(T.self)") as! T
    }
    
    ///Get instance from specific Storyboard
    class func getInstanceFromStoryboard<T: UIViewController>(_ storyboard: String) -> T
    {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: "\(T.self)") as! T
    }
}

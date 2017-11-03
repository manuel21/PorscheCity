//
//  Toast.swift
//  IAR
//
//  Created by Gerardo on 26/01/16.
//  Copyright © 2016 IamResponding. All rights reserved.
//

import UIKit

class Toast: NSObject {

    class func showInView(_ view: UIView, withText text: String, duration: TimeInterval = 3) {
        let toast = UILabel()
        toast.numberOfLines = 0
        toast.font = UIFont.systemFont(ofSize: 15)
        toast.text = text
        
        toast.frame.size = toast.sizeThatFits(CGSize(width: view.frame.width - 40, height: 500))
        
        toast.backgroundColor = UIColor.clear
        toast.textColor = UIColor.white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        backgroundView.alpha = 0
        backgroundView.layer.cornerRadius = 3
        backgroundView.frame = CGRect(x: 0, y: 0, width: toast.frame.width + 20, height: toast.frame.height + 20)
        backgroundView.frame.origin.x = (view.frame.width - backgroundView.frame.width) / 2
        backgroundView.frame.origin.y = view.frame.maxY - backgroundView.frame.height - 30
        toast.frame.origin.x = (backgroundView.frame.width - toast.frame.width) / 2
        toast.frame.origin.y = (backgroundView.frame.height - toast.frame.height) / 2
        backgroundView.addSubview(toast)
        
        backgroundView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin]
        
        view.addSubview(backgroundView)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            backgroundView.alpha = 1
            }) { (finished) -> Void in
                UIView.animate(withDuration: 0.5, delay: duration, options: .beginFromCurrentState, animations: { () -> Void in
                    backgroundView.alpha = 0
                    }) { (finished) -> Void in
                        backgroundView.removeFromSuperview()
                }
        }
        
    }
}

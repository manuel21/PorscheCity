//
//  NotificationController.swift
//  WatchApp Extension
//
//  Created by Gerardo on 31/10/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class NotificationController: WKUserNotificationInterfaceController {

    @IBOutlet weak var interfaceImage: WKInterfaceImage!
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        if let rawType = notification.request.content.userInfo["NotificationType"] as? Int,
            let type = NotificationType(rawValue: rawType) {
            var imageName = ""
            switch type {
            case .hotelCheckIn:
                imageName = "hotelCheckIn"
            case .hotelValet:
                imageName = "hotelValet"
            case .restaurantHost:
                imageName = "restaurantHost"
            case .restaurantValet:
                imageName = "restaurantValet"
            case .shuttleDriver:
                imageName = "shuttleDriver"
            }
            
            interfaceImage.setImageNamed(imageName)
        }
        
        completionHandler(.custom)
    }
}

//
//  AppDelegate.swift
//  Porsche City
//
//  Created by Manuel Salinas on 10/30/17.
//  Copyright © 2017 mxnuel. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            print("granted: " + (success ? "YES" : "NO"))
        }
        
        return true
    }

    public func scheduleNotification(type: NotificationType) {
        let title = "Porsche City Notification"
        let message = getMessageForNotification(type)
        
//        scheduleLocalNotification(type: type, title: title, message: message)
        sendSMS(message: title + ": " + message)
    }
    
    private func scheduleLocalNotification(type: NotificationType, title: String, message: String) {
        let notif = UNMutableNotificationContent()
        notif.body = message
        notif.title = title
        notif.userInfo = ["NotificationType": type.rawValue];
        notif.categoryIdentifier = "imageCategory"
        notif.sound = UNNotificationSound.default()
    
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "localNotif", content: notif, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if (error == nil) {
                print("Scheduled notification:" + String(describing:type))
            } else {
                print(error!)
            }
        }
    }
    
    private func sendSMS(message: String)
    {
        let body = "StatusID=" + message
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        HTTPRequestApi.executeRequest(url: "http://allencass.com/clients/kaaboo/twiloPorsche.php", requestType: .post, headers: headers, body: body) {
            (response, json, error) in
            
            if error != nil {
                print(error!)
            } else {
                if let statusCode = response?.statusCode {
                    print("SMS sent with response: \(statusCode)")
                } else {
                    print("SMS sent with response: null")
                }
            }
        }
    }
    
    private func getMessageForNotification(_ type: NotificationType) -> String {
        switch type {
            case .hotelCheckIn:
                return "Your luggage will be delivered to the room #964"
            case .hotelValet:
                return "Mr. Parker is waiting for you at the hotel entrance"
            case .restaurantHost:
                return "Mr. Parker will Arrive in 15 minutes"
            case .restaurantValet:
                return "Mr. Parker will arrive in 5 minutes with the car C66PG7"
            case .shuttleDriver:
                return "Mr. Parker will take you to Waldorf Astoria 9850 Wilshire Blvd"
            case .porscheValet:
                return "Your car GTY984 will be taken in Hermes 330 Rodeo Dr"
            case .porscheValet2:
                return "Your car GTY984 is arriving to Burberry, 130 Canon Dr"
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("")
    }
}


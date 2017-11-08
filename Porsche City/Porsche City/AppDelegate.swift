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

    public func createNotification(type: NotificationType) {
        let message = "a message" //TODO: poner el mensaje que se enviará, checar si son mensajes diferentes para cada tipo de notificación
        
        let notif = UNMutableNotificationContent()
        notif.body = message
        notif.title = "New Porsche City Notification"
        notif.userInfo = ["NotificationType": type.rawValue];
        notif.categoryIdentifier = "imageCategory"
        notif.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "localNotif", content: notif, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if (error == nil) {
                print("Scheduled notification:" + String(describing:type))
//                Toast.showInView((self.window!.rootViewController!.presentedViewController ?? self.window!.rootViewController!).view, withText: "Notification Scheduled")
            } else {
                print(error!)
            }
        }
        
        sendSMS(message: message)
    }
    
    func sendSMS(message: String) {
        let json = "{'StatusID':'" + message + "'}"
        HTTPRequestApi.executeRequest(url: "http://allencass.com/clients/kaaboo/twiloPorsche.php", requestType: .post, headers: nil, json: json) {
            (response, json, error) in
            
            print("SMS sent with response: \(response!.statusCode)")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("")
    }
}


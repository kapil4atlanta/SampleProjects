//
//  Singleton.swift
//  Bluetooth_LowEnergyDemo
//
//  Created by Kapil Rathan on 5/1/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import Foundation
import UserNotifications

//Model singleton so that we can refer to this from throughout the app.
let appControllerSingletonGlobal = Singleton()


// this class is a singleton
//
class Singleton: NSObject {
    
    class func sharedInstance() -> Singleton {
        return appControllerSingletonGlobal
    }
    
    
    
    // used by BLE stack
    let serialQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default) //DispatchQueue(label: "my serial queue")
    
    // Be careful. those class cannot use appController, because it would be a cyclic redundance
    //  let bluetoothController = BluetoothController()
    //  let tools = Tools()
    
    // App restore after IOS killed it, and bluetooth status has changed : device switch on, or advertise something.
    var appRestored = false
    var peripheralManagerToRestore = ""
    
    // logger
    //  let logger = Log()
    
    func scheduleNotification(title: String, message: String, inSeconds : TimeInterval){
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
        content.sound = UNNotificationSound.default()
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                // Handle any errors
            }
        }
    }
    
    
}

//
//  AppDelegate.swift
//  Bluetooth_LowEnergyDemo
//
//  Created by Kapil Rathan on 5/1/18.
//  Copyright © 2018 Kapil Rathan. All rights reserved.
//

import UIKit
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var centralManager = CBCentralManager()
    let singleton = Singleton.sharedInstance()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // if waked up by the system, with bluetooth identifier in parameter :
        // We need to initialize a central manager, with same name.
        // a bluetooth event accoured.
        //
        if let peripheralManagerIdentifiers: [String] = launchOptions?[UIApplicationLaunchOptionsKey.bluetoothPeripherals] as? [String]{
            if peripheralManagerIdentifiers.count > 1 {
                // TODO : manage this case
            }
            if peripheralManagerIdentifiers.count == 1 {
                // only one central Manager to initialize again
                let identifier = peripheralManagerIdentifiers.first
                
                print("UIApplicationLaunchOptionsKey.bluetoothPeripherals] : ")
                print("App was closed by system. will restore the peripheral manager ")
                print("--> " + identifier!)
                
                // flag allowing to know that we need to restore the central manager
                singleton.appRestored = true
                // name of central manager to restore
                singleton.peripheralManagerToRestore = identifier!
                singleton.scheduleNotification(title: "Did Wake up from Dead_app",  message: "Hey I am still here", inSeconds: 5)
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


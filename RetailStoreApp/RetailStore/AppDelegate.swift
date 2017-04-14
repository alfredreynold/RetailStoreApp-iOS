//
//  AppDelegate.swift
//  RetailStore
//
//  Created by Alfred Reynold on 4/13/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import UIKit
import CoreData
import RetailStoreModel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if !UserDefaults.standard.bool(forKey: "CreatedMockData") {
            let modelBundle = Bundle(identifier: "com.alfred.RetailStoreModel")
            if let path = modelBundle?.path(forResource: "items", ofType: "json") {
                do {
                    let jsonString = try String.init(contentsOfFile: path, encoding: .utf8)
                    DataManager.sharedManager.parseStoreJSONData(jsonString: jsonString)
                    let user = User(context: DataManager.sharedManager.container.viewContext)
                    user.name = "Thought Works"
                    user.id = 1
                    DataManager.sharedManager.saveContext()
                    UserDefaults.standard.set(true, forKey: "CreatedMockData")
                    UserDefaults.standard.synchronize()
                    print("Mock created")
                } catch {
                    print("Error while reading json file")
                }
            }
        }
        print("bundlePath \(Bundle.main.bundlePath)")
        print("\n\nresourcePath \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        DataManager.sharedManager.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        DataManager.sharedManager.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        DataManager.sharedManager.saveContext()
    }

}


//
//  AppDelegate.swift
//  Bloard
//
//  Created by Georges Kanaan on 10/30/14.
//  Copyright (c) 2014 Georges Kanaan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //set default values if first launch
        if (NSUserDefaults.standardUserDefaults().boolForKey("firstLaunch") == true) {
            
            //set default values
            var sharedDefaults = NSUserDefaults(suiteName: "group.com.ge0rges.bloard")
            sharedDefaults!.setFloat(0.3372549, forKey: "KBBackgroundColorShade")
            sharedDefaults!.setFloat(0.43921569, forKey: "KBKeysColorShade")
            sharedDefaults!.setBool(true, forKey: "inApp")
            sharedDefaults?.synchronize()
            
            //set the bool
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstLaunch")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        //update defaults
        var sharedDefaults = NSUserDefaults(suiteName: "group.com.ge0rges.bloard")
        sharedDefaults!.setBool(false, forKey: "inApp")
        sharedDefaults?.synchronize()

    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //update defaults
        var sharedDefaults = NSUserDefaults(suiteName: "group.com.ge0rges.bloard")
        sharedDefaults!.setBool(true, forKey: "inApp")
        sharedDefaults?.synchronize()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


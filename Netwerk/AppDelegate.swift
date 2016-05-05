//
//  AppDelegate.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/23/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Register and connect with Parse backend.
        // Parse backend for Peregrind; commented out for testing
//        Parse.setApplicationId("oNWlowHHo7G4KbhnA4zyDjygMZ38avt3zBFBfUni", clientKey: "mxkEtd1rMq94xG1URi0J9qQeHdHB8QTrGLnXf81e")
        
        
        // Parse backend for testing
        // TODO: change to one above once have pulling from server working
        Parse.setApplicationId("fiKid2BWAYs20Ry1f2zP05XKxmW1vGKIWJMXFJn3", clientKey: "mGitwGHnym3bAdyJavZvCd6Pbw9JRLAOGXEWSz1K")
        
        // log in as meredith
        PFUser.logInWithUsernameInBackground("Meredith", password: "bananarama") { user, error in
            if user != nil {
//                self.performSegueWithIdentifier(self.tableViewWallSegue, sender: nil)
                print("logged in as Meredith")
            } else if let error = error {
//                self.showErrorView(error)
                print("error logging in")
            }
        }
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


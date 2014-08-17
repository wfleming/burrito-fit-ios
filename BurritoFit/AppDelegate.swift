//
//  AppDelegate.swift
//  BurritoFit
//
//  Created by Will Fleming on 8/17/14.
//  Copyright (c) 2014 Will Fleming. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ZeroPushDelegate {
                            
  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
    //ZeroPush setup
    ZeroPush.engageWithAPIKey("HS8zsszZNboML3myKh1x", delegate: self) // currently the dev key: update for environments later
    // registerForRemoteNotificationTypes is deprecated in iOS 8
    // it's unclear to me if the new-style will also work on iOS 7
//    ZeroPush.shared().registerForRemoteNotificationTypes(
//      UIRemoteNotificationType.Alert | UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound
//    )
    application.registerForRemoteNotifications()
    let notificationTypes = (UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge)
    application.registerUserNotificationSettings(
      UIUserNotificationSettings(
        forTypes: notificationTypes,
        categories: NSSet()
      )
    )

    // Google Anlytics init
    GAI.sharedInstance().trackerWithTrackingId("UA-53906906-2")

    // default defaults
    NSUserDefaults.standardUserDefaults().registerDefaults(["apiToken": ""])

    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    GAI.sharedInstance().defaultTracker.set(kGAISessionControl, value: "end")
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
    GAI.sharedInstance().defaultTracker.set(kGAISessionControl, value: "start")
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    GAI.sharedInstance().dispatch()
  }

  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    NSLog("application didRegisterForRemoteNotificationsWithDeviceToken")
    ZeroPush.shared().registerDeviceToken(deviceToken)
    
    let tokenString = ZeroPush.deviceTokenFromData(deviceToken)
    //TODO: store this token & push it to server when we have a user
    NSLog("got a tokenString: %@", tokenString)
  }

  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    NSLog("application didFailToRegisterForRemoteNotificationsWithError: %@", error)
  }

  func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    NSLog("application didRegisterUserNotificationSettings: %@", notificationSettings)
  }
}


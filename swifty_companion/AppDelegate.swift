//
//  AppDelegate.swift
//  swifty_companion
//
//  Created by owalid on 15/11/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import UIKit
import SDWebImageSwiftUI
import SDWebImageSVGCoder

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static var orientationLock = UIInterfaceOrientationMask.portrait
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
      return AppDelegate.orientationLock
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    return true
  }

    // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      // Called when a new scene session is being created.
      // Use this method to select a configuration to create the new scene with.
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      // Called when the user discards a scene session.
      // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
      // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

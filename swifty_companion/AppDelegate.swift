//
//  AppDelegate.swift
//  swifty_companion
//
//  Created by owalid on 15/11/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import UIKit
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let handle = OAuth2Swift(
        consumerKey:    "********",
        consumerSecret: "********",
        authorizeUrl:   "https://api.instagram.com/oauth/authorize",
        responseType:   "token"
    ).authorize(
        withCallbackURL: "oauth-swift://oauth-callback/instagram",
        scope: "likes+comments", state:"INSTAGRAM") { result in
        switch result {
        case .success(let (credential, response, parameters)):
          print(credential.oauthToken)
          // Do your request
        case .failure(let error):
          print(error.localizedDescription)
        }
    }
  
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey  : Any] = [:]) -> Bool {
      if url.host == "oauth-callback" {
        OAuthSwift.handle(url: url)
      }
      return true
    }
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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


//
//  AppDelegate.swift
//  InstaLike
//
//  Created by Naveena vishnu on 10/24/20.
//  Copyright © 2020 vishnaveena. All rights reserved.
//

import UIKit

//importing the installed Parse pod:
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // below adding info that lets me connect my Parse backend to my InstaLike app:
        let parseConfig = ParseClientConfiguration {
                $0.applicationId = "NHolWyZagqiQKsxXwn2HHPDs5qTYSuLgkM2Cy9HY" // my app id from Parse
                $0.clientKey = "P5ArCYJ5uNYHu5McojaExC8fFxL621r09SjKzwFm" // <- my client key from Parse
                $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
        // --- end of Parse connection
        
        
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


//
//  AppDelegate.swift
//

import UIKit

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
}

extension AppDelegate {
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      window?.rootViewController = UINavigationController(rootViewController: ViewController())
      window?.makeKeyAndVisible()
      return true
   }
}

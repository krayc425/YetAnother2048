//
//  AppDelegate.swift
//  YetAnother2048
//
//  Created by 宋 奎熹 on 2018/8/6.
//  Copyright © 2018 宋 奎熹. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if let nav = self.window?.rootViewController as? UINavigationController,
            let gvc = nav.viewControllers[0] as? ViewController,
            !gvc.gameModel.isLose {
            GameHelper.shared.saveGame(gvc.gameModel)
        }
    }

}

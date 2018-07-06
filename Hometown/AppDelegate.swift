//
//  AppDelegate.swift
//  Hometown
//
//  Created by 王浩 on 2018/7/6.
//  Copyright © 2018年 haoge. All rights reserved.
//

import UIKit
import pop
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        initAppearance()
        // window(使用sb选择性的初始化rootViewController会导致异常释放)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initRootViewController()
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()

        return true
    }

    fileprivate func initAppearance() {
        // ios 9
        window?.tintColor = kThemeColor
        
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = kThemeColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UIToolbar.appearance().tintColor = kThemeColor
        UITextField.appearance().tintColor = kThemeColor
        UITextView.appearance().tintColor = kThemeColor
        UITabBar.appearance().tintColor = kThemeColor
    }
    
    fileprivate func initRootViewController() -> UIViewController? {
        let root: UIViewController?
        if !UserManager.sharedInstance.openId.isEmpty {
           root = getStoryboardInstantiateViewController(identifier: "Main")
        } else {
           root = getStoryboardInstantiateViewController(identifier: "loginNav")
        }
        return root
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

    // MARK: - Public
    func changeRootViewController(_ root: UIViewController, animated:Bool) {
        window?.rootViewController = root
        
        if animated {
            let layer = root.view.layer
            layer.pop_removeAllAnimations()
            root.view.pop_removeAllAnimations()
            
            let width = window?.frame.width ?? 0;
            let height = window?.frame.height ?? 0;
            let move = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
            move?.springBounciness = 16;
            move?.springSpeed = 10;
            move?.fromValue = NSValue(cgPoint: CGPoint(x: width*1.5, y: height*0.5))
            layer.pop_add(move, forKey: "position")
        }
    }

}


//
//  AppDelegate.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 17/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import UIKit
import CoreData
import ACProgressHUD_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //For progressHUD initial configuration purpose only
        configureProgressHUD()
        
        //For navigationbar configuration
        setupAppearances()
        return true
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CaseStudy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - NavigationBar Configuration
    private func setupAppearances() {
        UINavigationBar.appearance().tintColor = UIColor.CaseStudyBlueColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17),
                                                            NSForegroundColorAttributeName: UIColor.CaseStudyBlueColor()]
    }
    
    // MARK: - ProgressHUD Configuration
    func configureProgressHUD() {
        
        // Configure the Progress HUD one time for using in App.
        ACProgressHUD.shared.configureProgressHudStyle(withProgressText: "Hey Please wait...", progressTextColor: UIColor.black,hudBackgroundColor: UIColor.white, shadowColor: UIColor.black, shadowRadius: 10, cornerRadius: 5, indicatorColor: UIColor.orange, enableBackground: false, backgroundColor: UIColor.black, backgroundColorAlpha: 0.3, enableBlurBackground: false,showHudAnimation: .growIn,dismissHudAnimation: .growOut)
    }
    
    // MARK: - ProgressHUD Mehods
    func showProgressHUD(message: String) {
        ACProgressHUD.shared.showHUD(withStatus: message)
    }
    
    func hideProgressHUD() {
         ACProgressHUD.shared.hideHUD()
    }
    
    // MARK: - Custom functions
    func applyTraitsFromFont(_ f1: UIFont, to f2: UIFont) -> UIFont? {
        let t = f1.fontDescriptor.symbolicTraits
        if let fd = f2.fontDescriptor.withSymbolicTraits(t) {
            return UIFont.init(descriptor: fd, size: 0)
        }
        return nil
    }
    
    func stringFromHtml(string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: .unicode, allowLossyConversion: true)
            if let d = data {
                let str = try NSMutableAttributedString(data: d,
                                                        options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                        documentAttributes: nil)
                
                str.enumerateAttribute(
                    NSFontAttributeName,
                    in:NSMakeRange(0,str.length),
                    options:.longestEffectiveRangeNotRequired) { value, range, stop in
                        let f1 = value as! UIFont
                        let f2 = UIFont(name:"HelveticaNeue", size:17)!
                        if let f3 = applyTraitsFromFont(f1, to:f2) {
                            str.addAttribute(NSFontAttributeName, value: f3, range: range)
                        }
                }
                return str
            }
        } catch {
        }
        return nil
    }
}


//
//  AppDelegate.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 19/03/23.
//

import UIKit
import CoreData
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var elCenter : CLLocationCoordinate2D?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NetMonitor.shared.startMonitoring()
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
                        print(familyName, fontNames)
                    })
        
        var window = UIWindow(frame: UIScreen.main.bounds)
               
               // create story board. Default story board will be named as Main.storyboard in your project.
              
               
               // create view controllers from storyboard
               // Make sure you set Storyboard ID for both the viewcontrollers in
               // Interface Builder -> Identitiy Inspector -> Storyboard ID
        let story = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = story.instantiateViewController(withIdentifier:  "VCmapa")
        //let compraViewController = story.instantiateViewController(withIdentifier: "VCcompra")
           let pruebaController = story.instantiateViewController(withIdentifier: "VCprueba")
        let detalleViewController = story.instantiateViewController(withIdentifier: "VCdetalle")
              
               
              
        
        let nav1 = UINavigationController(rootViewController: MainTabController()) // ViewController inside TabBar
        nav1.tabBarItem.title = "WHERE"
        nav1.tabBarItem.image = UIImage(named: "house.fill")
        
       
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = [ nav1,pruebaController, mapViewController, detalleViewController] // All VCs, what you want in TabBar
        window.rootViewController = tabBarVC
        window.makeKeyAndVisible()
 
        
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "inversiones_ios")
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

}


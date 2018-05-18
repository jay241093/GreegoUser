//
//  AppDelegate.swift
//  greegotaxiapp
//
//  Created by jay on 4/2/18.
//  Copyright © 2018 jay. All rights reserved.
///Users/mac/Desktop/Greego-Greego-Dharika/greegotaxiapp/Profile/FreetripsViewController.swift

import UIKit
import GoogleMaps
import GooglePlaces

import UserNotifications
import Firebase
import Stripe
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate
{
    
    var window: UIWindow?
   
    
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        GMSServices.provideAPIKey("AIzaSyCTYoZFJBLdRwY9QdneWtG4LvwVuzSw_AM")
        GMSPlacesClient.provideAPIKey("AIzaSyAyvGa8vAvoiFNgAUo8QW7zh8qJbBn8X8o")
        STPPaymentConfiguration.shared().publishableKey = "pk_test_GF0y48SCqViKdCSA8LwOPFVj"
       IQKeyboardManager.shared.enable = true
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            Messaging.messaging().delegate = self

        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        
//        if UserDefaults.standard.bool(forKey: "isLoggedIn")
//        {
//            let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = testController
//        }
        
        // Override point for customization after application launch.
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
        
        print("Token is here   \(String(describing: Messaging.messaging().fcmToken))")
        print("Token is here   \(String(describing: Messaging.messaging().apnsToken))")
        
        UserDefaults.standard.set(Messaging.messaging().fcmToken, forKey: "FCMToken")
        UserDefaults.standard.synchronize()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let user = UserDefaults.standard
        
        user.set(fcmToken,forKey:"Token")
        user.synchronize()
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = InstanceID.instanceID().token()
        print("InstanceID token: \(String(describing: refreshedToken))")
        
        connectToFcm()
    }
    
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        
        
        print(userInfo as! NSDictionary)
        
        let state:UIApplicationState = application.applicationState
        
        let dic: NSDictionary = userInfo as! NSDictionary
        if(state == .active)
            
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
            
            
            
        }
        
        
        
    }
    
  
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //MARK: Connectivity Method
    class func hasConnectivity() -> Bool {
    
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
}

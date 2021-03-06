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
import Bugsnag
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate
{
    
    var window: UIWindow?
  var bgtask = UIBackgroundTaskIdentifier(0)
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        
        Bugsnag.start(withApiKey: "05f4f3a3580c0c58df6c0b721a34b5b6")

        GMSServices.provideAPIKey("AIzaSyDSNE3M1W24PtzNegO8PrHz6fzr_q_C4Ec")
        GMSPlacesClient.provideAPIKey("AIzaSyAzv2MkDftvd8cpKUl_tTXfCBWVpVaxUPQ")
        STPPaymentConfiguration.shared().publishableKey = "pk_live_C88eqn44CTqQzJ9FAdwrsYKl"
        
       IQKeyboardManager.shared.enable = true
        
      
        if launchOptions != nil {
            // opened from a push notification when the app is closed
            var userInfo = launchOptions![.remoteNotification] as? [AnyHashable: Any]
            if userInfo != nil {
                
                
                let dic = userInfo as! NSDictionary
                if let key = dic.object(forKey: "status")
                {
                    
                    var num = dic.value(forKey: "status") as! String
                    if(num == "2")
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "DrideMapVC") as! DrideMapVC
                        navigationController.pushViewController(initialViewController, animated: true)
                        self.window?.rootViewController = navigationController
                        self.window?.makeKeyAndVisible()
                        let dic: NSDictionary = userInfo as! NSDictionary
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
                        
                    }
                    if(num == "3")
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "OnTripVC") as! OnTripVC
                        navigationController.pushViewController(initialViewController, animated: true)
                        self.window?.rootViewController = navigationController
                        self.window?.makeKeyAndVisible()
                        let dic: NSDictionary = userInfo as! NSDictionary
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
                        
                    }
                    if(num == "4")
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "OnTripVC") as! OnTripVC
                        navigationController.pushViewController(initialViewController, animated: true)
                        self.window?.rootViewController = navigationController
                        self.window?.makeKeyAndVisible()
                        let dic: NSDictionary = userInfo as! NSDictionary
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
                       
                    }
                
                        
            

            }
                else
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "DrideMapVC") as! DrideMapVC
                    navigationController.pushViewController(initialViewController, animated: true)
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                    let dic: NSDictionary = userInfo as! NSDictionary
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
                    
                }
            }
            else
            {
               
             
            }
        }
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
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
   
    
    
  
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo as! NSDictionary)
        
        
        completionHandler(.newData)
        let state:UIApplicationState = application.applicationState
        
        
        let dic: NSDictionary = userInfo as! NSDictionary
        
        UserDefaults.standard.set(dic, forKey: "userinfo")
        UserDefaults.standard.synchronize()
        
        
        if let key = dic.object(forKey: "status")
        {
            
            var num = dic.value(forKey: "status") as! String
            if(num == "2")
            {
                UserDefaults.standard.set("2", forKey: "status")
                UserDefaults.standard.synchronize()
            }
            else if(num == "3")
            {
                UserDefaults.standard.set("3", forKey: "status")
                UserDefaults.standard.synchronize()
            }
            else if(num == "4")
            {
                UserDefaults.standard.set("4", forKey: "status")
                UserDefaults.standard.synchronize()
            }
            
        }
        else
        {
            UserDefaults.standard.set("1", forKey: "status")
            UserDefaults.standard.synchronize()
            
            
        }

        if(state == .active)
            
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)

        }
        else if(state == .background )
        {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
            
        }
        else
        {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Acceptnotification"), object: dic)
            
        }
        
    }
   
 
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    
    }
    
  
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        bgtask = application.beginBackgroundTask(expirationHandler: {
            self.bgtask = UIBackgroundTaskInvalid
        })
        
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

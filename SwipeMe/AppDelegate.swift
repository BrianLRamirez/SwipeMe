//
//  AppDelegate.swift
//  SwipeMe
//
//  Created by Brian Ramirez on 8/17/16.
//  Copyright © 2016 Brian Ramirez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import SwiftSpinner
import FirebaseInvites

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
               
        if(Reachability.isConnectedToNetwork()){
            
            //Firebase app configuration
            
            FIRApp.configure()
        
            //Google Sign in configuration
            GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
            GIDSignIn.sharedInstance().delegate = self
            
        }
        
        //Make status bar pretty
        UIApplication.sharedApplication().statusBarStyle = .LightContent
         UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
       
        registerForPushNotifications(application)
        
        

        
        return true
    }
  

    
      func registerForPushNotifications(application: UIApplication) {
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
   
    func application(application: UIApplication, didRegisterForPushNotificationsWithDeviceToken deviceToken: NSData) {
        print("DEVICE TOKEN = \(deviceToken)")
    }
    
    func application(application: UIApplication, didFailToRegisterForPushNotificationsWithError error: NSError) {
        print(error)
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        //let aps = userInfo["aps"] as! [String: AnyObject]
        // If your app was running and in the foreground
        // Or
        // If your app was running or suspended in the background and the user brings it to the foreground by tapping the push notification
    }
    
    //Google sign in setup
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
            sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
            annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
        
    }
    
   
    
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if let invite = FIRInvites.handleURL(url, sourceApplication:sourceApplication, annotation:annotation) as? FIRReceivedInvite {
            let matchType =
                (invite.matchType == FIRReceivedInviteMatchType.Weak) ? "Weak" : "Strong"
            print("Invite received from: \(sourceApplication) Deeplink: \(invite.deepLink)," +
                "Id: \(invite.inviteId), Type: \(matchType)")
            return true
        }
        
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //Google sign in setup
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
        SwiftSpinner.show("Signing In..")
            if let error = error {
                 SwiftSpinner.show("Failed to sign in. Try again later.", animated: false)
                print(error.localizedDescription)
                return
            }
            let authentication = user.authentication
            let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                accessToken: authentication.accessToken)
           
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                let triggerTime1 = (Int64(NSEC_PER_SEC) * 2)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime1), dispatch_get_main_queue(), { () -> Void in
                    SwiftSpinner.show("Welcome, \(user!.displayName!)", animated: false)
                })
                
                let triggerTime = (Int64(NSEC_PER_SEC) * 4)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                    SwiftSpinner.hide()
                })
            }
        
        
        
    }
    
    //Google sing in setup
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
            // Perform any operations when the user disconnects from app here.
            // ...
    }
    
    
   
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
   

}


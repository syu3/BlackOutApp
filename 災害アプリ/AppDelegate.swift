//
//  AppDelegate.swift
//  災害アプリ
//
//  Created by 加藤健一 on 2018/09/11.
//  Copyright © 2018年 加藤健一. All rights reserved.
//

import UIKit
import Firebase
import NotificationCenter
import UserNotificationsUI
import UserNotifications
import MapKit
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var iphone4 : CGRect = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 480.0)
    var iphone5 : CGRect = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 568.0)
    var iphone6 : CGRect = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0)
    var iphone6Plus : CGRect = CGRect(x: 0.0, y: 0.0, width: 414.0, height: 736.0)
    var iphoneX : CGRect = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 812.0)
    
    var ipad : CGRect = CGRect(x: 0.0, y: 0.0, width: 768.0, height: 1024.0)
    var ipad2 : CGRect = CGRect(x: 0.0, y: 0.0, width: 1536.0, height: 2048.0)
    var ipad3 : CGRect = CGRect(x: 0.0, y: 0.0, width: 2048.0, height: 2732.0)
    var ipad4 : CGRect = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0)
    
    var situationNum = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        FirebaseApp.configure()
        let screenWidth = Int( UIScreen.main.bounds.size.width);
        
        //スクリーンの高さ
        let screenHeight = Int(UIScreen.main.bounds.size.height);
        
        //CGRectで取得
        let rect : CGRect = UIScreen.main.bounds;
        NSLog("syu")
        
        print(rect)
        
        NSLog("w")
        print(screenWidth)
        NSLog("h")
        print(screenHeight)
        
        
        
        if(rect == iphone4){
            NSLog("iphone4")
            let storyboard: UIStoryboard = UIStoryboard(name: "3.5inch", bundle: Bundle.main)
            let mainViewController: UIViewController = storyboard.instantiateInitialViewController() as UIViewController!
            self.window?.rootViewController = mainViewController
            
            
            
        }else if(rect == iphone5){
            let storyboard: UIStoryboard = UIStoryboard(name: "4inch", bundle: Bundle.main)
            let mainViewController: UIViewController = storyboard.instantiateInitialViewController() as UIViewController!
            self.window?.rootViewController = mainViewController
            NSLog("iphone5")
            
            
            
        }else if(rect == iphone6){
            let storyboard: UIStoryboard = UIStoryboard(name: "4.7inchh", bundle: Bundle.main)
            let mainViewController: UIViewController = storyboard.instantiateInitialViewController() as UIViewController!
            self.window?.rootViewController = mainViewController
            
            
            NSLog("iphone6")
        }else if(rect == iphone6Plus){
            let storyboard: UIStoryboard = UIStoryboard(name: "5.5inch", bundle: Bundle.main)
            let mainViewController: UIViewController = storyboard.instantiateInitialViewController()as UIViewController!
            self.window?.rootViewController = mainViewController
            NSLog("iphone6Plus")
        }else if(rect == iphoneX){
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let mainViewController: UIViewController = storyboard.instantiateInitialViewController()as UIViewController!
            self.window?.rootViewController = mainViewController
            NSLog("iphoneX")
        }else if(rect == ipad || rect == ipad2 || rect == ipad3 || rect == ipad4){
            NSLog("ipad")
            let storyboard: UIStoryboard = UIStoryboard(name: "3.5inch", bundle: Bundle.main)
            let mainViewController: UIViewController = storyboard.instantiateInitialViewController() as UIViewController!
            self.window?.rootViewController = mainViewController
        }
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        
        
        // ここに初期化処理を書く
        // UserDefaultsを使ってフラグを保持する
        let userDefault = UserDefaults.standard
        // "firstLaunch"をキーに、Bool型の値を保持する
        let dict = ["firstLaunch": true]
        // デフォルト値登録
        // ※すでに値が更新されていた場合は、更新後の値のままになる
        userDefault.register(defaults: dict)
        
        // "firstLaunch"に紐づく値がtrueなら(=初回起動)、値をfalseに更新して処理を行う
        print("ええええ",userDefault.bool(forKey: "firstLaunch"))
        if userDefault.bool(forKey: "firstLaunch") {
            userDefault.set(false, forKey: "firstLaunch")
            
            print("初回起動の時だけ呼ばれるよ")
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(AppDelegate.timerUpdate), userInfo: nil, repeats: false)
            
        }
       
        
        return true
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        if(situationNum == 2){
            print(situationNum)
            //　通知設定に必要なクラスをインスタンス化
            let trigger: UNNotificationTrigger
            let content = UNMutableNotificationContent()
            var notificationTime = DateComponents()
            
            // トリガー設定
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 43200, repeats: false)
            // 通知内容の設定
            content.title = "大丈夫ですか？"
            content.body = "まだ停電していますか？電気が通っている場合は、アプリを開いて状況を変更してください！"
            content.sound = UNNotificationSound.default()
            
            // 通知スタイルを指定
            let request = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)
            // 通知をセット
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
    }
    
    
    @objc func timerUpdate() {

        
        let alert: UIAlertController = UIAlertController(title: "おねがい", message: "停電状況が変わった場合は、できるだけ早く変更するようにしてください。\n停電していないのに停電と選択したままにしていると、ほかのユーザーの方が不安になります。\nご協力おねがします。", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        // ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        //            presentViewController(alert, animated: true, completion: nil)
        
        
        self.window?.rootViewController!.present(alert, animated: true, completion: nil)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    //    func applicationDidEnterBackground(_ application: UIApplication) {
    //        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    //        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        completionHandler([])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        completionHandler()
    }
}

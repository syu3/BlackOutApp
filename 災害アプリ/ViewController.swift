//
//  ViewController.swift
//  災害アプリ
//
//  Created by 加藤健一 on 2018/09/11.
//  Copyright © 2018年 加藤健一. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import GoogleMobileAds
import Firebase
import NotificationCenter
import UserNotificationsUI
import UserNotifications
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,UNUserNotificationCenterDelegate {
    //test
    //自分の家が今停電していないのに、アプリ上の状況を「停電した」としている方は、「電気がついている」ボタンを押して状況を変更してください。よろしくお願いします。
    var lat = ""
    
    var lon = ""
    var situationNum = 0
    var interstitial: GADInterstitial!
    // 経度緯度.変更
    let myLan: CLLocationDegrees = 37.331741
    let myLon: CLLocationDegrees = -122.030333
    var myCenter: CLLocationCoordinate2D!
    var myLocationManager: CLLocationManager!
    var num = 0
    var situation = 0
    var openNum = 0
    var situationArray = Array<String>()
    var ref: DatabaseReference!
    var addpinnum = -1
    var situationDictionary: [String: String] = [:]
    //    @IBOutlet var myMapView:MKMapView!
    
    @IBOutlet weak var myMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                if granted {
                    print("通知許可")
                    
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self as! UNUserNotificationCenterDelegate
                    
                } else {
                    print("通知拒否")
                }
            })
            
        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7890542862997264/4279565442")
        let request = GADRequest()
        interstitial.load(request)
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.showAd), userInfo: nil, repeats: true)
        // Use Firebase library to configure APIs
        
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        // LocationManagerの生成.
        myLocationManager = CLLocationManager()
        
        // Delegateの設定.
        myLocationManager.delegate = self
        
        // 距離のフィルタ.
        myLocationManager.distanceFilter = 100.0
        
        // 精度.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {
            
            print("not determined")
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            myLocationManager.requestWhenInUseAuthorization()
        }
        
        myMapView.delegate = self
        
        if(UserDefaults.standard.integer(forKey: "openNum") != 0){
            
            
            ref = Database.database().reference()
            ref.child("data").observe(.childChanged, with: { [weak self](snapshot) -> Void in
                self?.num = (self?.num)! + 1
                print("a",snapshot)
                print("b",snapshot.childSnapshot)
                let storePlace = String(describing: snapshot.childSnapshot(forPath: "userPlace").value!)
                print("faf",snapshot.childSnapshot(forPath: "userPlace").value!)
                let SituationFir = String(describing: snapshot.childSnapshot(forPath: "Situation").value!)
                print("こんにちは",SituationFir)
                self?.situationArray.append(SituationFir)
                self?.situationDictionary[storePlace] = SituationFir
                self?.situationNum = 1
                //                for i in (self?.situationArray)! {
                //                    print("iは、",i)
                //                    if(i == "aa"){
                //                        self?.situation = 0
                //                    }else if(i == "yes"){
                //                        self?.situation = 1
                //                    }else if(i == "no"){
                //                        self?.situation = 2
                //                    }
                // ピンを生成.
                let myPin: MKPointAnnotation = MKPointAnnotation()
                // 座標を設定.
                print("mmmmm")
                myPin.coordinate = CLLocationCoordinate2DMake(Double(storePlace.components(separatedBy: "|")[0])!, Double(storePlace.components(separatedBy: "|")[1])!)
                // タイトルを設定.
                myPin.title = SituationFir
                print("fawefa",myPin)
                // MapViewにピンを追加.
                self?.myMapView.addAnnotation(myPin)
                
            })
            ref.child("data").observe(.childAdded, with: { [weak self](snapshot) -> Void in
                self?.num = (self?.num)! + 1
                print("a",snapshot)
                print("b",snapshot.childSnapshot)
                let storePlace = String(describing: snapshot.childSnapshot(forPath: "userPlace").value!)
                print("faf",snapshot.childSnapshot(forPath: "userPlace").value!)
                let SituationFir = String(describing: snapshot.childSnapshot(forPath: "Situation").value!)
                print("こんにちは",SituationFir)
                self?.situationArray.append(SituationFir)
                self?.situationDictionary[storePlace] = SituationFir
                self?.situationNum = 1
                //                for i in (self?.situationArray)! {
                //                    print("iは、",i)
                //                    if(i == "aa"){
                //                        self?.situation = 0
                //                    }else if(i == "yes"){
                //                        self?.situation = 1
                //                    }else if(i == "no"){
                //                        self?.situation = 2
                //                    }
                // ピンを生成.
                let myPin: MKPointAnnotation = MKPointAnnotation()
                // 座標を設定.
                print("mmmmm")
                myPin.coordinate = CLLocationCoordinate2DMake(Double(storePlace.components(separatedBy: "|")[0])!, Double(storePlace.components(separatedBy: "|")[1])!)
                // タイトルを設定.
                myPin.title = SituationFir
                print("fawefa",myPin)
                // MapViewにピンを追加.
                self!.myMapView.addAnnotation(myPin)
                
            })
            print(UserDefaults.standard.integer(forKey: "openNum"))
            var openNum = UserDefaults.standard.integer(forKey: "openNum")
            openNum = openNum + 1
            UserDefaults.standard.set(1, forKey: "openNum")
        }else{
        }
        if(UserDefaults.standard.integer(forKey: "openNum") != 0){
            //            FirebaseApp.configure()
            if(lat == "" || lon == ""){
                if(UserDefaults.standard.string(forKey: "lat") != nil){
                    lat = UserDefaults.standard.string(forKey: "lat")!
                    lon = UserDefaults.standard.string(forKey: "lon")!
                    print("はい",lat,lon)
                    if(lat == "" || lon == ""){
                        print("は1い")
                        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerUpdate), userInfo: nil, repeats: false)
                    }
                }else{
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerUpdate), userInfo: nil, repeats: false)
                }
            }else{
                UserDefaults.standard.set(lat, forKey: "lat")
                UserDefaults.standard.set(lon, forKey: "lon")
                
                var aa: [String: String] = ["userPlace": self.lat + "|" + self.lon,"Situation":"aa"]
                // Get the download URL for 'images/stars.jpg'
                if let range = self.lat.range(of: ".") {
                    self.lat.replaceSubrange(range, with: "a")
                    if let range = self.lon.range(of: ".") {
                        var ref: DatabaseReference!
                        
                        ref = Database.database().reference()
                        self.lon.replaceSubrange(range, with: "a")
                        print(self.lat + "b" + self.lon)
                        ref.child("data/" + self.lat + "b" + self.lon).setValue(aa)
                        print("abc",aa)
                    }
                }
            }
        }else{
            
            print("えええ",UserDefaults.standard.integer(forKey: "openNum"))
            UserDefaults.standard.set(1, forKey: "openNum")
            
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerUpdate), userInfo: nil, repeats: false)
        }
        
        
    }
    @objc func showAd(){
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
    }
    @objc func timerUpdate() {
        print("update")
        performSegue(withIdentifier: "first",sender: nil)
    }
    
    @IBAction func tuiteru(){
        situationNum = 2
        if(lat != "" || lon != ""){
            print("へへh",lat,"ほほほ")
            if let range = self.lat.range(of: "a") {
                lat.replaceSubrange(range, with: ".")
                if let range = self.lon.range(of: "a") {
                    lon.replaceSubrange(range, with: ".")
                    myCenter = CLLocationCoordinate2DMake(CLLocationDegrees(lat)!, CLLocationDegrees(lon)!)
                    
                    self.situation = 1
                    // ピンを生成.
                    let myPin: MKPointAnnotation = MKPointAnnotation()
                    // 座標を設定.
                    print("mmmmm")
                    myPin.coordinate = CLLocationCoordinate2DMake(Double(lat)!, Double(lon)!)
                    print("fawefa",myPin)
                    // MapViewにピンを追加.
                    self.myMapView.addAnnotation(myPin)
                    
                    var aa: [String: String] = ["userPlace": self.lat + "|" + self.lon,"Situation":"yes"]
                    // Get the download URL for 'images/stars.jpg'
                    if let range = self.lat.range(of: ".") {
                        self.lat.replaceSubrange(range, with: "a")
                        if let range = self.lon.range(of: ".") {
                            
                            self.lon.replaceSubrange(range, with: "a")
                            print(self.lat + "b" + self.lon)
                            ref.child("data/" + self.lat + "b" + self.lon).setValue(aa)
                            print("abc",aa)
                            
                        }
                    }
                }
            }else{
                myCenter = CLLocationCoordinate2DMake(CLLocationDegrees(lat)!, CLLocationDegrees(lon)!)
                
                self.situation = 1
                // ピンを生成.
                let myPin: MKPointAnnotation = MKPointAnnotation()
                // 座標を設定.
                print("mmmmm")
                myPin.coordinate = CLLocationCoordinate2DMake(Double(lat)!, Double(lon)!)
                print("fawefa",myPin)
                // MapViewにピンを追加.
                self.myMapView.addAnnotation(myPin)
                
                var aa: [String: String] = ["userPlace": self.lat + "|" + self.lon,"Situation":"yes"]
                // Get the download URL for 'images/stars.jpg'
                if let range = self.lat.range(of: ".") {
                    self.lat.replaceSubrange(range, with: "a")
                    if let range = self.lon.range(of: ".") {
                        
                        self.lon.replaceSubrange(range, with: "a")
                        print(self.lat + "b" + self.lon)
                        ref.child("data/" + self.lat + "b" + self.lon).setValue(aa)
                        print("abc",aa)
                        
                    }
                }
            }
            var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.situationNum = situation
        }
    }
    @IBAction func teiden(){
        
        
        situationNum = 2
        //        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.situationNum = situationNum
        
        if(lat != "" || lon != ""){
            print("へへh",lat,"ほほほ")
            if let range = self.lat.range(of: "a") {
                lat.replaceSubrange(range, with: ".")
                if let range = self.lon.range(of: "a") {
                    lon.replaceSubrange(range, with: ".")
                    myCenter = CLLocationCoordinate2DMake(CLLocationDegrees(lat)!, CLLocationDegrees(lon)!)
                    
                    self.situation = 2
                    // ピンを生成.
                    let myPin: MKPointAnnotation = MKPointAnnotation()
                    // 座標を設定.
                    print("mmmmm")
                    myPin.coordinate = CLLocationCoordinate2DMake(Double(lat)!, Double(lon)!)
                    print("fawefa",myPin)
                    // MapViewにピンを追加.
                    self.myMapView.addAnnotation(myPin)
                    
                    var aa: [String: String] = ["userPlace": self.lat + "|" + self.lon,"Situation":"no"]
                    // Get the download URL for 'images/stars.jpg'
                    if let range = self.lat.range(of: ".") {
                        self.lat.replaceSubrange(range, with: "a")
                        if let range = self.lon.range(of: ".") {
                            
                            self.lon.replaceSubrange(range, with: "a")
                            print(self.lat + "b" + self.lon)
                            ref.child("data/" + self.lat + "b" + self.lon).setValue(aa)
                            print("abc",aa)
                            
                        }
                    }
                }
            }else{
                myCenter = CLLocationCoordinate2DMake(CLLocationDegrees(lat)!, CLLocationDegrees(lon)!)
                
                self.situation = 2
                // ピンを生成.
                let myPin: MKPointAnnotation = MKPointAnnotation()
                // 座標を設定.
                print("mmmmm")
                myPin.coordinate = CLLocationCoordinate2DMake(Double(lat)!, Double(lon)!)
                print("fawefa",myPin)
                // MapViewにピンを追加.
                self.myMapView.addAnnotation(myPin)
                
                var aa: [String: String] = ["userPlace": self.lat + "|" + self.lon,"Situation":"no"]
                // Get the download URL for 'images/stars.jpg'
                if let range = self.lat.range(of: ".") {
                    self.lat.replaceSubrange(range, with: "a")
                    if let range = self.lon.range(of: ".") {
                        
                        self.lon.replaceSubrange(range, with: "a")
                        print(self.lat + "b" + self.lon)
                        ref.child("data/" + self.lat + "b" + self.lon).setValue(aa)
                        print("abc",aa)
                        
                    }
                }
            }
            var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.situationNum = situation
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if(situationNum == 1){
            addpinnum = addpinnum + 1
            print("じゃない")
            let myIdentifier = "myPin"
            
            var myAnnotation: MKAnnotationView!
            
            // annotationが見つからなかったら新しくannotationを生成.
            if myAnnotation == nil {
                myAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: myIdentifier)
                print("ファwフェアおgじゃおいwgホイあfヘアいうwfハオfじゃおいウェア",annotation.coordinate.latitude)
            }
            print("situationArrayは,",situationArray)
            print("situationArray[addpinnum]は,",situationDictionary[String(annotation.coordinate.latitude) + "|" + String(annotation.coordinate.longitude)])
            if(situationDictionary[String(annotation.coordinate.latitude) + "|" + String(annotation.coordinate.longitude)] == "aa"){
                // 画像を選択.
                myAnnotation.image = UIImage(named: "white.png")!
            }else if(situationDictionary[String(annotation.coordinate.latitude) + "|" + String(annotation.coordinate.longitude)] == "yes"){
                // 画像を選択.
                myAnnotation.image = UIImage(named: "pin.png")!
            }else if(situationDictionary[String(annotation.coordinate.latitude) + "|" + String(annotation.coordinate.longitude)] == "no"){
                // 画像を選択.
                myAnnotation.image = UIImage(named: "gray.png")!
            }
            myAnnotation.annotation = annotation
            
            return myAnnotation
        }else{
            let myIdentifier = "myPin"
            
            var myAnnotation: MKAnnotationView!
            
            // annotationが見つからなかったら新しくannotationを生成.
            if myAnnotation == nil {
                myAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: myIdentifier)
                print("ファwフェアおgじゃおいwgホイあfヘアいうwfハオfじゃおいウェア",myAnnotation)
            }
            if(situation == 0){
                // 画像を選択.
                myAnnotation.image = UIImage(named: "white.png")!
            }else if(situation == 1){
                // 画像を選択.
                myAnnotation.image = UIImage(named: "pin.png")!
            }else if(situation == 2){
                // 画像を選択.
                myAnnotation.image = UIImage(named: "gray.png")!
            }
            myAnnotation.annotation = annotation
            
            return myAnnotation
        }
    }
    
    
}


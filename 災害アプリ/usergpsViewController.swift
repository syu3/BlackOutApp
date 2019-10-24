//
//  usergpsViewController.swift
//  災害アプリ
//
//  Created by 加藤健一 on 2018/09/12.
//  Copyright © 2018年 加藤健一. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class usergpsViewController: UIViewController, UITextFieldDelegate,CLLocationManagerDelegate,MKMapViewDelegate {
    var locationManager = CLLocationManager()
    let myPin: MKPointAnnotation = MKPointAnnotation()
    @IBOutlet weak var usergpsmap: MKMapView!
    @IBOutlet var usergpsField: UITextField!
    var userlat = ""
    var userlon = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        locationManager.delegate = self
        usergpsField.delegate = self
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(usergpsViewController.recognizeLongPress(sender:)))
        
        // MapViewにUIGestureRecognizerを追加.
        usergpsmap.addGestureRecognizer(myLongPress)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // GPSから値を取得した際に呼び出されるメソッド.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        print("ああああああああ",myPin)
        if(myPin != nil){
            usergpsmap.removeAnnotation(myPin)
        }
        print("へへへh")
        // 配列から現在座標を取得.
        
        let myLocations: NSArray = locations as NSArray
        
        var myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        
        var myLocation:CLLocationCoordinate2D = myLastLocation.coordinate
        
        // Regionを作成.
        //        let myRegion  = MKCoordinateRegionMakeWithDistance(myLocation, myLatDist, myLonDist);
        
        
        
        print(myLocation.latitude)
        print(myLocation.longitude)
        let myLat = myLocation.latitude
        let myLon = myLocation.longitude
        
        
        userlat = String(myLat)
        userlon = String(myLon)
        
        
        // 中心点を指定.
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon)
        
        // MapViewに中心点を設定.
        usergpsmap.setCenter(center, animated: true)
        
        // 縮尺(表示領域)を指定.
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMake(center, mySpan)
        
        // MapViewにregionを追加.
        usergpsmap.region = myRegion
        //        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        // 座標を設定.
        myPin.coordinate = center
        
        // タイトルを設定.
        myPin.title = ""
        myPin.subtitle = ""
        
        
        // MapViewにピンを追加.
        usergpsmap.addAnnotation(myPin)
        
        
        
        
        // geocoderを作成.
        let myGeocorder = CLGeocoder()
        
        // locationを作成.
        let myLocation1 = CLLocation(latitude: myLat, longitude: myLon)
        
        // 逆ジオコーディング開始.
        myGeocorder.reverseGeocodeLocation(myLocation1, completionHandler: { (placemarks, error) -> Void in
            
            for placemark in placemarks! {
                
                print("Name: \(String(describing: placemark.name))")
                print("Country: \(String(describing: placemark.country))")
                print("ISOcountryCode: \(String(describing: placemark.isoCountryCode))")
                print("administrativeArea: \(String(describing: placemark.administrativeArea))")
                print("subAdministrativeArea: \(String(describing: placemark.subAdministrativeArea))")
                print("Locality: \(String(describing: placemark.locality))")
                print("PostalCode: \(String(describing: placemark.postalCode))")
                print("areaOfInterest: \(String(describing: placemark.areasOfInterest))")
                print("Ocean: \(String(describing: placemark.ocean))")
                
                self.usergpsField.text =  placemark.administrativeArea! + placemark.locality! + placemark.name!
                
            }
        })
        
        
    }
   
    /*
     長押しを感知した際に呼ばれるメソッド.
     */
    @objc func recognizeLongPress(sender: UILongPressGestureRecognizer) {
        
        
        // 長押しの最中に何度もピンを生成しないようにする.
        if sender.state != UIGestureRecognizerState.began {
            return
        }
        
        // 長押しした地点の座標を取得.
        let location2 = sender.location(in: usergpsmap)
        print("ははははっははははh" , location2)
        
        // locationをCLLocationCoordinate2Dに変換.
        let myCoordinate: CLLocationCoordinate2D = usergpsmap.convert(location2, toCoordinateFrom: usergpsmap)
        print("ははははっははははh" , myCoordinate.latitude,myCoordinate.longitude)
        // geocoderを作成.
        let myGeocorder = CLGeocoder()
        
        // locationを作成.
        let myLocation1 = CLLocation(latitude: myCoordinate.latitude, longitude: myCoordinate.longitude)
        userlat = String(myCoordinate.latitude)
        userlon = String(myCoordinate.longitude)
        
        // 逆ジオコーディング開始.
        myGeocorder.reverseGeocodeLocation(myLocation1, completionHandler: { (placemarks, error) -> Void in
            
            for placemark in placemarks! {
                
                print("Name: \(String(describing: placemark.name))")
                print("Country: \(String(describing: placemark.country))")
                print("ISOcountryCode: \(String(describing: placemark.isoCountryCode))")
                print("administrativeArea: \(String(describing: placemark.administrativeArea))")
                print("subAdministrativeArea: \(String(describing: placemark.subAdministrativeArea))")
                print("Locality: \(String(describing: placemark.locality))")
                print("PostalCode: \(String(describing: placemark.postalCode))")
                print("areaOfInterest: \(String(describing: placemark.areasOfInterest))")
                print("Ocean: \(String(describing: placemark.ocean))")
                
                if(placemark.administrativeArea != nil){
                    self.usergpsField.text =  placemark.administrativeArea! + placemark.locality! + placemark.name!
                }
            }
        })
        
        if(myPin != nil){
            usergpsmap.removeAnnotation(myPin)
        }
        //        storePlaceMap.removeAnnotation(storePlaceMap.annotations as! MKAnnotation)
        
        
        // ピンを生成.
        //        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        // 座標を設定.
        myPin.coordinate = myCoordinate
        
        // タイトルを設定.
        myPin.title = ""
        
        // サブタイトルを設定.
        myPin.subtitle = ""
        
        // MapViewにピンを追加.
        usergpsmap.addAnnotation(myPin)
    }
    
    /*
     addAnnotationした際に呼ばれるデリゲートメソッド.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let myPinIdentifier = "PinAnnotationIdentifier"
        
        // ピンを生成.
        let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
        
        // アニメーションをつける.
        myPinView.animatesDrop = true
        
        // コールアウトを表示する.
        myPinView.canShowCallout = true
        
        // annotationを設定.
        myPinView.annotation = annotation
        
        return myPinView
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    @IBAction func getGps(){
        // 距離のフィルタ.
        locationManager.distanceFilter = 100.0
        
        // 精度.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {
            
            print("not determined")
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            locationManager.requestWhenInUseAuthorization()
        }
        
        // 位置情報の更新を開始.
        locationManager.startUpdatingLocation()
        
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.tag == 1){
            print("ハオfヲイアフェじゃオイfへわお")
            
            
            // geocoderを作成.
            let myGeocoder: CLGeocoder = CLGeocoder()
            
            // 検索する住所.
            let myAddress: String = usergpsField.text!
            
            // 正ジオコーディング開始
            myGeocoder.geocodeAddressString(myAddress, completionHandler: { (placemarks, error) -> Void in
                
                for placemark in placemarks! {
                    // locationにplacemark.locationをCLLocationとして代入する
                    let location: CLLocation = placemark.location!
                    print("Latitude: \(location.coordinate.latitude)")
                    print("Longitude: \(location.coordinate.longitude)")
                    
                    self.userlat = String(location.coordinate.latitude)
                    self.userlon = String(location.coordinate.longitude)
                    // 中心点を指定.
                    let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                    
                    // MapViewに中心点を設定.
                    self.usergpsmap.setCenter(center, animated: true)
                    
                    // 縮尺(表示領域)を指定.
                    let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                    let myRegion: MKCoordinateRegion = MKCoordinateRegionMake(center, mySpan)
                    
                    // MapViewにregionを追加.
                    self.usergpsmap.region = myRegion
                    
                    // 座標を設定.
                    self.myPin.coordinate = center
                    
                    // タイトルを設定.
                    //                    self.myPin.title = "指定した住所の位置"
                    
                    
                    // MapViewにピンを追加.
                    self.usergpsmap.addAnnotation(self.myPin)
                }
            })
            
            
            
        }
    }
    
    // このメソッドで渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "data" {
            
            let ViewController:ViewController = segue.destination as! ViewController
            
            // 変数:遷移先ViewController型 = segue.destinationViewController as 遷移先ViewController型
            // segue.destinationViewController は遷移先のViewController
            
            ViewController.lon = self.userlon
            ViewController.lat = self.userlat
        }
        
    }
    
    @IBAction func back(){
        performSegue(withIdentifier: "data",sender: nil)
    }


}

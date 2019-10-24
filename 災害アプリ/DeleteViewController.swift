//
//  DeleteViewController.swift
//  PowerCuts
//
//  Created by 加藤健一 on 2019/10/11.
//  Copyright © 2019 加藤健一. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class DeleteViewController: UIViewController {
    // インスタンス変数
    var DBRef:DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        //インスタンスを作成
        DBRef = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func delete(){
        let data = ["Situation": "aa"]
        DBRef.child("data/")..updateChildValues(data)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

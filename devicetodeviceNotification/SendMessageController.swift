//
//  ViewController.swift
//  devicetodeviceNotification
//
//  Created by Luis S Ramos on 11/3/17.
//  Copyright © 2017 Tech Build Dreams. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
class SendMessageController: UIViewController {
    
    let text: UITextField = {
        let text = UITextField()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 1
        text.placeholder = "Type message"
        return text
    }()
    let button : UIButton = {
        let button = UIButton(type: .system)
       button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 0.85, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(sendMenssage), for: .touchUpInside)
        button.setTitle("Send Message", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHUBS()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))

    }
    
    @objc func logout()
    {
       try! Auth.auth().signOut()
       present(LoginViewController(), animated: true, completion: nil)
    }

    
//    function to send a message using the to id and the firebase token id
    @objc func sendMenssage()
    {
        Database.database().reference().child("users").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary =  snapshot.value as? [String:Any] else {return}
            
            dictionary.forEach({ (key,value) in
                guard let uid = Auth.auth().currentUser?.uid else {return}
                if key != uid{
                    let ref = Database.database().reference().child("messages").child(uid)
                    guard let messageText = self.text.text else {return}

                    let value = ["message":messageText,"fromDevice":AppDelegate.DEVICEID,"fromId":uid,"toId":key] as[String:Any]

                    ref.updateChildValues(value)
                    self.fetchmessages(toId: key)
                }
            })
        }
     
      
    }
//
    
    
    
    
//    fetch user to get user id and firebase token id
    
    func fetchmessages(toId: String)
    {
        Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            let fromDevice = dictionary["fromDevice"] as! String
            
            print(fromDevice)
            self.setupPushNotification(fromDevice: fromDevice)
        }
    }
    
    
    
/*
 here we are posting the push notification using alamoire http request
 check documentation https:firebase.google.com/docs/cloud-messaging/ios/topic-messaging
 
 
 

 */

    fileprivate func setupPushNotification(fromDevice:String)
    {
        guard let message = text.text else {return}
        let title = "tech build dreams"
        let body = message
        let toDeviceID = fromDevice
        var headers:HTTPHeaders = HTTPHeaders()
        
        headers = ["Content-Type":"application/json","Authorization":"key=\(AppDelegate.SERVERKEY)"
        
        ]
        let notification = ["to":"\(toDeviceID)","notification":["body":body,"title":title,"badge":1,"sound":"default"]] as [String:Any]
        
        Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
        }
  
    }

//    input fields contraints
fileprivate func setupHUBS()
{
//    message and username text field
    view.addSubview(text)
    text.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    text.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant:-100 ).isActive = true
    text.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-40).isActive = true
    text.heightAnchor.constraint(equalToConstant: 50).isActive = true

    
// submit button  constrains
    view.addSubview(button)
    button.topAnchor.constraint(equalTo: text.bottomAnchor,constant:8).isActive = true
    button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
 }
    
}

//
//  LoginViewController.swift
//  devicetodeviceNotification
//
//  Created by Luis S Ramos on 11/3/17.
//  Copyright © 2017 Tech Build Dreams. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    
//        MARK login inputs and button
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.text  = "Log in"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let logintText: UITextField = {
        let text = UITextField()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 1
        text.placeholder = "Enter email"
        return text
    }()
    
    
    let loginPassword: UITextField = {
        let text = UITextField()
        text.placeholder = "enter password"
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 1
        return text
    }()
    
    
    let loginBtn : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setTitle("Log in", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 0.85, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    
//    MARK registration input below
    
    let registerLabel: UILabel = {
        let label = UILabel()
        label.text  = "Register"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let text: UITextField = {
        let text = UITextField()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 1
        text.placeholder = "Enter email"
        return text
    }()
    
    let password: UITextField = {
        let text = UITextField()
        text.placeholder = "enter password"
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 1
        return text
    }()
    
    let button : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setTitle("Register", for: .normal);
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 0.85, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogInOrNot()
        setupHUBS()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    
//     checking if the user is logged in or not...
//    if user is logged in update user from device id
    func checkLogInOrNot()
    {
        if Auth.auth().currentUser?.uid != nil
        {
            let meggageController = UINavigationController(rootViewController: SendMessageController())
            present(meggageController, animated: true, completion: nil)
        }
    }
    
    
 //   simple user registration tutorial purpose...
    @objc func register()
    {
        
        guard let email = text.text else {return}
        guard let password = password.text else {return}
        Auth.auth().createUser(withEmail:email , password: password) { (user, err) in
            if err != nil{
                print("check your credential please",err?.localizedDescription ?? "")
            }
            else
            {
                guard let uid = user?.uid else {return}
                let values = ["Email":email,"password":password,"fromDevice":AppDelegate.DEVICEID] as [String : Any]
                let ref = Database.database().reference().child("users").child(uid)
                
                ref.updateChildValues(values)
                print("Succesfully registered")
                let meggageController = UINavigationController(rootViewController: SendMessageController())
                self.present(meggageController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    
//    login function
   @objc func login()
    {
        guard let email = logintText.text else {return}
          guard let password = loginPassword.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if err != nil{
                print("Failed to log in",err?.localizedDescription ?? "")
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let values = ["fromDevice":AppDelegate.DEVICEID] as [String : Any]
            let ref = Database.database().reference().child("users").child(uid)
            
            ref.updateChildValues(values)
            
            let meggageController = UINavigationController(rootViewController: SendMessageController())
            self.present(meggageController, animated: true, completion: nil)
        }
    }
    
    
    //    input fields contraints
    fileprivate func setupHUBS()
    {
//        MARK Login input
        
//        login label constraints
        view.addSubview(loginLabel)
        loginLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loginLabel.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-40).isActive = true
        loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginLabel.topAnchor.constraint(equalTo: view.topAnchor,constant:150 ).isActive = true
        
//        login email text field constraints
        view.addSubview(logintText)
        logintText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logintText.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-40).isActive = true
        logintText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logintText.topAnchor.constraint(equalTo: loginLabel.bottomAnchor,constant:20 ).isActive = true;
        
        
//        login password field constraints
        view.addSubview(loginPassword)
        loginPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginPassword.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-40).isActive = true
        loginPassword.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginPassword.topAnchor.constraint(equalTo: logintText.bottomAnchor,constant:8 ).isActive = true;
        
        
        
        // submit button  constrains
        view.addSubview(loginBtn)
        loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginBtn.topAnchor.constraint(equalTo: loginPassword.bottomAnchor,constant:8).isActive = true
        
        
//    MARK register input contraints
        
        view.addSubview(registerLabel)
        registerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        registerLabel.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-40).isActive = true
        registerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerLabel.topAnchor.constraint(equalTo: loginBtn.bottomAnchor,constant:100 ).isActive = true
        
        //    message and username text field
        view.addSubview(text)
        text.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        text.topAnchor.constraint(equalTo: registerLabel.bottomAnchor,constant:20).isActive = true
        text.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-40).isActive = true
        text.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        //    password text field
        view.addSubview(password)
        password.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        password.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-40).isActive = true
        password.heightAnchor.constraint(equalToConstant: 50).isActive = true
        password.topAnchor.constraint(equalTo: text.bottomAnchor,constant:8 ).isActive = true;
        
        // submit button  constrains
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.topAnchor.constraint(equalTo: password.bottomAnchor,constant:8).isActive = true

        
        
        
    }
}

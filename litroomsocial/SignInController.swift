//
//  SignInController.swift
//  litroomsocial
//
//  Created by Kuala on 2017-04-19.
//  Copyright © 2017 Litroom. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftKeychainWrapper

class SignInController: UIViewController {

    @IBOutlet weak var emailTxt: FancyTextField!
    @IBOutlet weak var passwordTxt: FancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: USER_IS_LOGGED_IN)
        if retrievedString != nil{
            print("Litroom: User is already logged in")
            performSegue(withIdentifier: "GoToFeed", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
       
    }

    @IBAction func signInBtnPressed(_ sender: Any) {
        if let email = emailTxt.text, let password = passwordTxt.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: password){(user,error) in
                if error == nil{
                    print("Litroom: firebase email login success")
                    
                   
                    self.signInDone(user: user,userData:  nil)
                    
                }else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: password){(user,error) in
                        if error != nil{
                            print("Litroom: error in creating user, err=\(error.debugDescription)")
                        }else{
                            print ("Litroom: creating new user success")
                        
                            self.signInDone(user: user,userData:  nil)
                        }
                    }
                    
                }
            }
        }
    }
    func signInDone(user: FIRUser?, userData: Dictionary<String,String>?){
        if let user = user{
            let saveSuccessful: Bool = KeychainWrapper.standard.set(user.uid, forKey: USER_IS_LOGGED_IN)
            if saveSuccessful{
                print("Litroom: keychain update success")
            }
            if userData == nil{
                DataService.ds.saveOrUpdateUser(uid: user.uid, userData: ["provider": user.providerID])
            }
            else{
                DataService.ds.saveOrUpdateUser(uid: user.uid, userData: userData!)
            }
            performSegue(withIdentifier: "GoToFeed", sender: nil)
        }
    }
    @IBAction func fbBtnPressed(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) {(result, error) in
            if error != nil{
                print("Litroom: error in facebook login, err=\(error.debugDescription)")
            }else if result?.isCancelled == true{
                print("Litroom: facebook login canceled")
            }else{
                print("Litroom: facebook login success")
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credentials: credentials)
            }
        }
    }
    func firebaseAuth(credentials: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credentials){(user, error) in
            if error != nil{
                print("Litroom: error in firebase login, err=\(error.debugDescription)")
                
            }else{
                print("Litroom: firbase login success")
                
                let userData = ["provider": credentials.provider]
                self.signInDone(user: user,userData: userData)
            }
        }
    }
}


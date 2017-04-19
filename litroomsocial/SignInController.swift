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

class SignInController: UIViewController {

    @IBOutlet weak var emailTxt: FancyTextField!
    @IBOutlet weak var passwordTxt: FancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInBtnPressed(_ sender: Any) {
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
            }
        }
    }
}


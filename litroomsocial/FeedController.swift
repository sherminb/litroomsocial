//
//  FeedController.swift
//  litroomsocial
//
//  Created by Kuala on 2017-04-19.
//  Copyright © 2017 Litroom. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedController: UIViewController,UITableViewDelegate,UITableViewDataSource {

     @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        return cell!
        
    }
    @IBAction func signOutTapped(_ sender: AnyObject) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: USER_IS_LOGGED_IN)
        
        print("Litroom: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "GoToSignIn", sender: nil)
    }

}

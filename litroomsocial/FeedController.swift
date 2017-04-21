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
     var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        DataService.ds.postsRef.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let post = Post(postKey: snap.key, dict: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            self.tableView.reloadData()
        })

        
        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            let post = posts[indexPath.row]
            cell.loadCell(post: post)
            return cell
        }
        return PostCell()
        
    }
    @IBAction func signOutTapped(_ sender: AnyObject) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: USER_IS_LOGGED_IN)
        
        print("Litroom: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "GoToSignIn", sender: nil)
    }

}

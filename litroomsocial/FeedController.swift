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

class FeedController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var captionTxt: FancyTextField!
    @IBOutlet weak var addImage: CircleImage!

     @IBOutlet weak var tableView: UITableView!
     var posts = [Post]()
    
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()//cashing images
    
    var imagePicker : UIImagePickerController!
    var imagePicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
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
            if let img = FeedController.imageCache.object(forKey: post.imageUrl as NSString){
                cell.loadCell(post: post,image: img)
                print("Litroom: loading image from cache")
            }else{
                cell.loadCell(post: post,image: nil)
            }
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
    @IBAction func addImageTapped(_ sender: AnyObject) {
        
        present(imagePicker, animated: true, completion: nil)

    }
    @IBAction func postTapped(_ sender: Any) {
        
        guard let caption = captionTxt.text, caption != "" else{
            return
        }
        guard let img = addImage.image, imagePicked == true else{
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(img, 0.2){
        
            let imageId = NSUUID().uuidString//get a unique random id
        
            let metaData = FIRStorageMetadata()
        
            metaData.contentType = "image/jpeg"
        
        
            DataService.ds.postsStorageRef.child(imageId).put(imageData, metadata: metaData){ (metaData,error) in
                
                if error != nil{
                    print("Litroom: error in saving firebase image")
                }else{
                    print("Litroom: saving image to firebase storage success")
                    
                    let downloadUrl = metaData?.downloadURL()?.absoluteString
                    
                }
            }
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            addImage.image = img
            imagePicked = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

//
//  PostCell.swift
//  litroomsocial
//
//  Created by Kuala on 2017-04-21.
//  Copyright © 2017 Litroom. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: CircleImage!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var likesRef : FIRDatabaseReference!
    var post : Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadCell(post: Post, image: UIImage?){
        self.post = post
        
        postText.text = post.caption
        
        likesLabel.text = "\(post.likes)"
        likesRef = DataService.ds.currentUserRef.child("likes").child(post.postKey)
        
        likesRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeImage.image = UIImage(named: "empty-heart")
            }
            else{
                self.likeImage.image = UIImage(named: "filled-heart")
            }
            })
        
        if image != nil{
            self.postImage.image = image
        }else
        {
        
            let storageRef = FIRStorage.storage().reference(forURL: post.imageUrl)
        
            storageRef.data(withMaxSize: 2 * 1024 * 1024, completion: {(data,error) in
            if error != nil{
                print("Litroom: error in downloading image from firebase")
            }else{
                print("Litroom: image download from firebase success")
                if let data = data{
                    if let img = UIImage(data: data){
                        self.postImage.image = img
                        FeedController.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                    }

                }
            }
            })
        }
        
    }
    func likeTapped(sender: UITapGestureRecognizer){
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeImage.image = UIImage(named: "filled-heart")
                self.likesRef.setValue(true)
                self.post.adjustLikes(liked: true)
                
            }else{
                self.likeImage.image = UIImage(named: "empty-heart")
                self.likesRef.removeValue()
                self.post.adjustLikes(liked: false)
            }
        })
    }
}

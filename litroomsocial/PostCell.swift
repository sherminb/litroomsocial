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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadCell(post: Post){
        self.postText.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        let storageRef = FIRStorage.storage().reference(forURL: post.imageUrl)
        storageRef.data(withMaxSize: 2 * 1024 * 1024, completion: {(data,error) in
            if error != nil{
                print("Litroom: error in downloading image from firebase")
            }else{
                print("Litroom: image download from firebase success")
                if let data = data{
                    if let img = UIImage(data: data){
                        self.postImage.image = img
                    }

                }
            }
        })
        
    }

}

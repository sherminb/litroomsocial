//
//  Post.swift
//  litroomsocial
//
//  Created by Kuala on 2017-04-21.
//  Copyright © 2017 Litroom. All rights reserved.
//

import Foundation

class Post{
    
    private var _caption : String!
    private var _imageUrl : String!
    private var _postKey : String!
    private var _likes : Int!
    
    var caption : String {
        return _caption
    }
    var imageUrl : String {
        return _imageUrl
    }
    var postKey : String {
        return _postKey
    }
    var likes : Int {
        return _likes
    }
    
    init (postKey : String,dict: Dictionary<String,AnyObject>){
        self._postKey = postKey
        if let caption = dict["caption"] as? String
        {
            self._caption = caption
        }
        if let imageUrl = dict["imageUrl"] as? String
        {
            self._imageUrl = imageUrl
        }
       
        if let likes = dict["likes"] as? Int
        {
            self._likes = likes
        }
    }
    
}

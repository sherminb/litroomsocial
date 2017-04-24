//
//  DataService.swift
//  litroomsocial
//
//  Created by Kuala on 2017-04-21.
//  Copyright © 2017 Litroom. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService{
    
    static let ds = DataService()
    
    private var _usersRef=DB_BASE.child("users")
    private var _postsRef = DB_BASE.child("posts")
    
    var usersRef: FIRDatabaseReference{
        return _usersRef}
    var postsRef : FIRDatabaseReference{
        return _postsRef}
    
    private var _postsStorageRef = STORAGE_BASE.child("posts")
    var postsStorageRef: FIRStorageReference{
        return _postsStorageRef
    }
    
    func saveOrUpdateUser(uid: String, userData: Dictionary<String, String>) {
        usersRef.child(uid).updateChildValues(userData)
    }
    
    
}

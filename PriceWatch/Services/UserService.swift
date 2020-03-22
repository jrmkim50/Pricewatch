//
//  UserService.swift
//  PriceWatch
//
//  Created by Min on 3/17/20.
//  Copyright © 2020 Min. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import MapKit
import GeoFire

struct UserService {
    
    static func userOnBoarding() -> Bool {
        let onBoardingStatus = UserDefaults.standard.bool(forKey: Constants.UserDefaults.onBoardingStatus)
        if (onBoardingStatus == true) {
            User.current.setOnBoardingStatus(onBoardingStatus: false, writeToUserDefaults: true)
            return true
        } else {
            return false
        }
    }
    
    static func createUser(name: String, email: String, username: String, password: String,
                           completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().root
        
        ref.child("usernames").child(username).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                return completion(nil)
            }
        })
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if (error == nil) {
                let usrAttrs = ["Name": name, "Email": email, "Username": username]
                ref.child("usernames").child(username).setValue(user?.user.uid)
                ref.child("users").child((user?.user.uid)!).setValue(usrAttrs, withCompletionBlock: {(error, ref) in
                    if let _ = error {
                        return completion(nil)
                    }
                    ref.observeSingleEvent(of: .value, with: {(snapshot) in
                        let user = User(snapshot: snapshot)
                        completion(user)
                    })
                })
            } else {
                return completion(nil)
            }
        })
    }
    
    static func logInUser(email: String, password: String, completion: @escaping (User?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if let _ = error {
                completion(nil)
            } else {
                guard let user = Auth.auth().currentUser else { return }
                let userRef = Database.database().reference().child("users").child(user.uid)
                userRef.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let user = User(snapshot: snapshot) {
                        completion(user)
                    }
                })
            }
        })
    }
    
    static func personalPosts(for user: User, completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("personal posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }

            let posts = snapshot.reversed().compactMap(Post.init)
            completion(posts)
        })
    }
    
    static func posts(for key: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("posts").child(key)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let dispatchGroup = DispatchGroup()
            if let post = Post(snapshot: snapshot) {
                dispatchGroup.enter()
                LikeService.isPostLiked(post) { (isLiked) in
                    post.isLiked = isLiked
                }
                LikeService.isPostDisliked(post) { (isDisliked) in
                    post.isDisliked = isDisliked
                    dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: .main, execute: {
                    completion(post)
                })
            } else {
                return completion(nil)
            }
            
        })
    }
    
    static func geoPosts(for location: CLLocation, completion: @escaping ([String], [CLLocation]) -> Void) {
        let geofireRef = Database.database().reference().child("post locations")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let circleQuery = geoFire.query(at: location, withRadius: 2)
        var keys = [String]()
        var locations = [CLLocation]()

        circleQuery.observe(.keyEntered, with: {(key, location) in
            guard let key = key as? String, let location = location as? CLLocation else {
                return completion([],[])
            }
            keys.append(key)
            locations.append(location)
        })
        
        circleQuery.observeReady({() in
            return completion(keys, locations)
        })
    }
}

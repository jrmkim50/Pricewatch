//
//  PostService.swift
//  PriceWatch
//
//  Created by Min on 3/19/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import MapKit
import GeoFire

struct PostService {
    static func create(for latitude: CLLocationDegrees, for longitude: CLLocationDegrees, for title: String, for description: String, for image: UIImage, for upvotes: Int = 0) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (imageURL) in
            guard let imageURL = imageURL else { return }
            let imageUrlString = imageURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(latitude: latitude, longitude: longitude, title: title, imageUrlString: imageUrlString, description: description, aspectHeight: aspectHeight, upvotes: upvotes)
        }
    }
    
    private static func create(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, imageUrlString: String, description: String, aspectHeight: CGFloat, upvotes: Int = 0) {
        let currentUser = User.current
        let post = Post(latitude: latitude, longitude: longitude, title: title, imageURL: imageUrlString, description: description, author: currentUser.username,imageHeight: aspectHeight, upvotes: upvotes)
        let dict = post.dictValue
        let geoFire = GeoFire(firebaseRef: Database.database().reference().child("post locations"))
        let postRef = Database.database().reference().child("posts").childByAutoId()
        postRef.updateChildValues(dict)
        let personalPostListRef = Database.database().reference().child("personal posts").child(currentUser.uid)
        personalPostListRef.child(postRef.key!).setValue("post key")
        geoFire.setLocation(CLLocation(latitude: latitude, longitude: longitude), forKey: postRef.key!)
        let likesRef = Database.database().reference().child("upvotes").child(postRef.key!).child(currentUser.uid).setValue("true")
        let dislikesRef = Database.database().reference().child("downvotes").child(postRef.key!).child(currentUser.uid).setValue("true")
    }

}

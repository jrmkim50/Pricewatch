import UIKit
import FirebaseDatabase.FIRDataSnapshot
import MapKit

class Post {
    var key: String?
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let title: String
    let imageURL: String
    let description: String
    let author: String
    let imageHeight: CGFloat
    let creationDate: Date
    var upvotes: Int = 0
    
    var isLiked: Bool = false
    var isDisliked: Bool = false
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, imageURL: String, description: String, author: String, imageHeight: CGFloat, upvotes: Int = 0) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.imageURL = imageURL
        self.description = description
        self.author = author
        self.imageHeight = imageHeight
        self.creationDate = Date()
        self.upvotes = upvotes
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let latitude = dict["latitude"] as? CLLocationDegrees,
              let longitude = dict["longitude"] as? CLLocationDegrees,
              let title = dict["title"] as? String,
              let description = dict["description"] as? String,
              let author = dict["author"] as? String,
              let imageURL = dict["image_url"] as? String,
              let imageHeight = dict["image_height"] as? CGFloat,
              let upvotes = dict["upvotes"] as? Int,
              let createdAgo = dict["created_at"] as? TimeInterval else { return nil}
        self.key = snapshot.key
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.imageURL = imageURL
        self.description = description
        self.author = author
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        self.upvotes = upvotes
        
    }
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        return ["latitude" : latitude,
                "longitude" : longitude,
                "title" : title,
                "description" : description,
                "author" : author,
                "image_url" : imageURL,
                "image_height" : imageHeight,
                "upvotes" : upvotes,
                "created_at" : createdAgo]
    }


    
}

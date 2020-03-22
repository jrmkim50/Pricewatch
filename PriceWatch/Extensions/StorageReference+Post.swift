import Foundation
import FirebaseStorage

extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()

    static func newPostImageReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())

        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
    
    static func newPostTextReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())

        return Storage.storage().reference().child("descriptions/posts/\(uid)/\(timestamp).txt")
    }
}

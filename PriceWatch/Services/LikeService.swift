import Foundation
import FirebaseDatabase

struct LikeService {
    static func like(for post: Post, success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        guard let key = post.key else { return }
        let likesRef = Database.database().reference().child("upvotes").child(key).child(currentUID)
        let opposingRef = Database.database().reference().child("downvotes").child(key).child(currentUID)
        likesRef.setValue("true") { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            opposingRef.removeValue(completionBlock: {(_, _) in
            })

            let likeCountRef = Database.database().reference().child("posts").child(key).child("upvotes")
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount + 1
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    success(false)
                } else {
                    success(true)
                }
            })
        }
    }
    
    static func dislike(for post: Post, success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        guard let key = post.key else { return }
        let likesRef = Database.database().reference().child("downvotes").child(key).child(currentUID)
        let opposingRef = Database.database().reference().child("upvotes").child(key).child(currentUID)
        likesRef.setValue("true") { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            opposingRef.removeValue(completionBlock: {(_, _) in
            })

            let likeCountRef = Database.database().reference().child("posts").child(key).child("upvotes")
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount - 1
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    success(false)
                } else {
                    success(true)
                }
            })
        }
    }
    
    static func isPostLiked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let postKey = post.key else {
            assertionFailure("Error: post must have key.")
            return completion(false)
        }

        let likesRef = Database.database().reference().child("upvotes").child(postKey)
        likesRef.child(User.current.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    static func isPostDisliked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let postKey = post.key else {
            assertionFailure("Error: post must have key.")
            return completion(false)
        }

        let likesRef = Database.database().reference().child("downvotes").child(postKey)
        likesRef.child(User.current.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    static func setIsLiked(_ isLiked: Bool, for post: Post, success: @escaping (Bool) -> Void) {
        if isLiked {
            like(for: post, success: success)
        } else {
            success(false)
        }
    }
    
    static func setIsDisliked(_ isDisliked: Bool, for post: Post, success: @escaping (Bool) -> Void) {
        if isDisliked {
            dislike(for: post, success: success)
        } else {
            success(false)
        }
    }



}

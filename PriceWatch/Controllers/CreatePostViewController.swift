//
//  CreatePostViewController.swift
//  PriceWatch
//
//  Created by Min on 3/18/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit
import MapKit

class CreatePostViewController: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var customerOrStore: UISegmentedControl!
    
    var annotation: MKPointAnnotation?
    
    let photoHelper = PWPhotoHelper()
    var placeHolderImage: UIImage?
    
    var uploadStatus: UploadStatus = UploadStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeHolderImage = postImage.image!
        setupToHideKeyboardOnTapOnView()
        setGradientBackground(rgbTop: [70.0, 153.0, 239.0], rgbBottom: [51.0, 116.0, 239.0])
        let padding = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 5)
        postDescription.textContainerInset = padding
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreatePostViewController.newImage(tapGestureRecognizer:)))
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(tapGestureRecognizer)
        photoHelper.completionHandler = { image in
            self.postImage.image = image
        }
    }
    
    @IBAction func uploadPost(_ sender: Any) {
        if let annotation = annotation, var postTitleText = postTitle.text, let postImageImage = postImage.image, !UIImage.areEqualImages(img1: postImageImage, img2: placeHolderImage!), postDescription.text.contains("Cost [MUST INCLUDE]:"), postDescription.text.count > 20 {
            if (customerOrStore.selectedSegmentIndex == 0) {
                postTitleText = "[CUSTOMER] " + postTitleText
            } else {
                postTitleText = "[STORE] " + postTitleText
            }
            PostService.create(for: annotation.coordinate.latitude, for: annotation.coordinate.longitude, for: postTitleText, for: postDescription.text!, for: postImageImage)
            uploadStatus.success = true
        }
    }

    
    @objc func newImage(tapGestureRecognizer: UITapGestureRecognizer) {
        photoHelper.presentActionSheet(from: self)
    }

}

extension UIImage {
    static func areEqualImages(img1: UIImage, img2: UIImage) -> Bool {
        guard let data1: NSData = img1.pngData() as NSData? else { return false }
        guard let data2: NSData = img2.pngData() as NSData? else { return false }
        return data1.isEqual(data2)
    }
}

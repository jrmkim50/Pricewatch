//
//  PostDetailsViewController.swift
//  PriceWatch
//
//  Created by Min on 3/20/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit
import Kingfisher
import GoogleMobileAds
import MessageUI

class PostDetailsViewController: UIViewController, GADBannerViewDelegate, MFMailComposeViewControllerDelegate {

    var postKey: String?
    var post: Post?
    var postUpvotes: Int = 0
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postAuthor: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postVote: UILabel!
    @IBOutlet weak var postDetails: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        likeButton.isUserInteractionEnabled = false
        dislikeButton.isUserInteractionEnabled = false
        setGradientBackground(rgbTop: [70.0, 153.0, 239.0], rgbBottom: [51.0, 116.0, 239.0])
        postDetails.numberOfLines = 0
        postDetails.frame = CGRect(x: 8,y: 31,width: 358,height: 237)
        postDetails.lineBreakMode = NSLineBreakMode.byWordWrapping
        postDetails.sizeToFit()
        postTitle.sizeToFit()
        postTitle.adjustsFontSizeToFitWidth = true
        postAuthor.sizeToFit()
        postAuthor.adjustsFontSizeToFitWidth = true
        UserService.posts(for: postKey!, completion: {(post) in
            if let post = post {
                self.post = post
                self.postUpvotes = post.upvotes
                self.postTitle.text = post.title
                self.postAuthor.text = post.author
                self.postVote.text = String(self.postUpvotes)
                self.postDetails.text = post.description
                let imageURL = URL(string: post.imageURL)
                self.postImage.kf.setImage(with: imageURL)
                self.likeButton.isUserInteractionEnabled = !(post).isLiked
                self.dislikeButton.isUserInteractionEnabled = !(post).isDisliked
            }   
        })
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-5286636125505263/1777023785"
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    @IBAction func upvote(_ sender: Any) {
        LikeService.setIsLiked(!(post!.isLiked), for: post!) { (success) in
            guard success else { return }
            self.postUpvotes+=1
            self.post!.upvotes = self.postUpvotes
            self.post!.isLiked = true
            self.post!.isDisliked = false
            self.likeButton.isUserInteractionEnabled = !(self.post!.isLiked)
            self.dislikeButton.isUserInteractionEnabled = !(self.post!.isDisliked)
            self.postVote.text = String(self.postUpvotes)
        }
    }
    
    @IBAction func downvote(_ sender: Any) {
        LikeService.setIsDisliked(!(post!.isDisliked), for: post!) { (success) in
            print(success)
            guard success else { return }
            self.postUpvotes-=1
            self.post!.upvotes = self.postUpvotes
            self.post!.isDisliked = true
            self.post!.isLiked = false
            self.likeButton.isUserInteractionEnabled = !(self.post!.isLiked)
            self.dislikeButton.isUserInteractionEnabled = !(self.post!.isDisliked)
            self.postVote.text = String(self.postUpvotes)
        }
    }
    @IBAction func markAsUrgent(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([""])
            MapService.determineState(from: post!.latitude, from: post!.longitude) { (state) in
                let messageText = "PriceWatch will compile daily reports and aims to send these to local officials \n" +
                                  "State: " + state + "\n" +
                                  "Report Details: " + self.postDetails.text!
                mail.setMessageBody(messageText, isHTML: true)
                self.present(mail, animated: true)
            }
        } else {
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: bottomLayoutGuide,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      // Add banner to view and add constraints as above.
        addBannerViewToView(bannerView)
    }

}

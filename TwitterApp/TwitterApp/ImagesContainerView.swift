//
//  ImagesContainerView.swift
//  TwitterApp
//
//  Created by RWuser on 16/03/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import SDWebImage
class ImagesContainerView: UIView {
    var nibName = "ImagesContainerView"
    var images: [Media]?
    
    @IBOutlet var imageView2Width: NSLayoutConstraint!
    @IBOutlet var imageView3Width: NSLayoutConstraint!
    @IBOutlet var imageView3Height: NSLayoutConstraint!
    @IBOutlet var imageView4Height: NSLayoutConstraint!

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let mainView = bundle.loadNibNamed(nibName, owner: self, options: nil)[0] as! UIView
        mainView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainView)
        let horizontalConstraintLeading = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        self.addConstraint(horizontalConstraintLeading)
        let horizontalConstraintTrailing = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        self.addConstraint(horizontalConstraintTrailing)
        let constraintTop = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.addConstraint(constraintTop)
        let constraintBottom = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.addConstraint(constraintBottom)
    }

    func drawAdditionalImages(images: [Media]) {
        self.images = images
        let imageCount = images.count

        if let imageView2Width = imageView2Width {
            switch imageCount {
            case 1:
                imageView2Width.active = true
                imageView3Width.active = true
                imageView3Height.active = false
                imageView4Height.active = true
            case 2:
                imageView2Width.active = false
                imageView3Width.active = false
                imageView3Height.active = true
                imageView4Height.active = true
            case 3:
                imageView2Width.active = false
                imageView3Width.active = false
                imageView3Height.active = false
                imageView4Height.active = true
            case 4:
                imageView2Width.active = false
                imageView3Width.active = false
                imageView3Height.active = false
                imageView4Height.active = false
            default:
                imageView2Width.active = false
                imageView3Width.active = false
                imageView3Height.active = false
                imageView4Height.active = false
            }
        }

        let imageViews = [imageView1, imageView2, imageView3, imageView4]
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
        }
        for i in 0..<imageCount {
            if let imageView = imageViews[i] {
                let tweetMedia =  images[i]
                let tweetImageURL = tweetMedia.media_url!
                let urlMedia = NSURL(string: tweetImageURL)
                imageView.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block)
            }
        }
        updateConstraintsIfNeeded()
    }
}
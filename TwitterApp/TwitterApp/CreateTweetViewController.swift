//
//  CreateTweetViewController.swift
//  TwitterApp
//
//  Created by RWuser on 09/03/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import MobileCoreServices
class CreateTweetViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let maxTweetSize = 140
    let symbolsInFirstImageLink = 23
    var images = [UIImage: Int]()
    
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var SymbolsCountItem: UIBarButtonItem!
    @IBOutlet weak var stackViewForImages: UIStackView!
    
    override func viewDidLoad() {
        tweetText.delegate = self
        updateSymbolsCount()
        images.removeAll()
    }
    
    @IBAction func TweetPressed(sender: AnyObject) {
        updateImagesAndTweet()
    }
    
    func updateImagesAndTweet(){
        if getSymbolsLeft() == maxTweetSize {
            return
        }
        for image in images.keys {
            if images[image] < 0 {
                NetworkService.uploadImage(image: image, success: {
                    mediaId in
                    self.images.updateValue(mediaId, forKey: image)
                    self.updateImagesAndTweet()
                    }, failure: {
                        _ in
                       NSLog("Error uploading image")
                })
                return
            }
        }
        let text = tweetText.text
        NetworkService.createTweet(tweetText: text, mediaIds: Array(images.values), success: {
            self.navigationController?.popViewControllerAnimated(true)
            }, failure: {error in
                NSLog("Error creating tweet")
        })
    }
    
    
    @IBAction func takePhotoItemPressed(sender: AnyObject) {
        if(images.count < 4){
            takePhoto()
        }
    }
    
    @IBAction func addImageItemPressed(sender: AnyObject) {
        if(images.count < 4){
            addImage()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newSize = textView.text.characters.count - range.length + text.characters.count
        if newSize > maxTweetSize {
            return false
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        updateSymbolsCount()
    }
    
    func updateSymbolsCount() {
        SymbolsCountItem.title = "\(getSymbolsLeft())"
    }
    
    func getSymbolsLeft() -> Int {
        var symbolsLeft = maxTweetSize - tweetText.text.characters.count
        if(images.count >= 1){
            symbolsLeft = symbolsLeft - symbolsInFirstImageLink
        }
        return symbolsLeft
    }
    
    func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            NSLog("Camera is not available")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(false, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        images[image!] = -1
        let imageWithButton = ImageWithButton()
        
        imageWithButton.clipsToBounds = true
        stackViewForImages.addArrangedSubview(imageWithButton)
        imageWithButton.imageView.image = image
        imageWithButton.buttonPress = {
            let image = image!
            imageWithButton.removeFromSuperview()
            self.images.removeValueForKey(image)
            self.updateSymbolsCount()
        }
        updateSymbolsCount()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
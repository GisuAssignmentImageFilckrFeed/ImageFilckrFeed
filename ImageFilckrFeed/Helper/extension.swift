//
//  extension.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-28.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

// cache images

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        //no flshing image for the next list
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: (urlString as NSString)){
            self.deleteActivityIndicator()
            self.image = cachedImage
            return
        }
        
        let url = NSURL(string: urlString)
        let request = URLRequest(url: url! as URL)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request){
            (data, response, error) in
            //download hit an error so lets return out
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!), let compressedImageData = UIImageJPEGRepresentation(downloadedImage, 0.1), let compressedImage = UIImage(data: compressedImageData) {
                    imageCache.setObject( compressedImage, forKey: (urlString as NSString))
                    self.deleteActivityIndicator()
                    self.image = compressedImage
                }
            }
        }
        dataTask.resume()
    }
    
    func deleteActivityIndicator() {
        if let imageView = self as? ImageViewWithActivityIndicator {
            imageView.activityIndicator.stopAnimating()
            imageView.activityIndicator.removeFromSuperview()
        }
    }
}

extension UIView {
    
    func formatDate(dateString: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormat.date(from: dateString) {
            dateFormat.dateFormat = "MMM d, yyyy"
            return dateFormat.string(from: date)
        }
        
        return "unidentified"
    }
    
    func setupActivityIndicator<T>(cell: T) {
        if let flickrImageView = (cell as? FeedCell)?.flickrImageView {
            flickrImageView.addSubview(flickrImageView.activityIndicator)
            flickrImageView.activityIndicator.centerYAnchor.constraint(equalTo: flickrImageView.centerYAnchor).isActive = true
            flickrImageView.activityIndicator.centerXAnchor.constraint(equalTo: flickrImageView.centerXAnchor).isActive = true
        }
    }
}

extension UIViewController {
    func alertMessage(message : String, rootController : UIViewController) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.view.layer.borderColor = UIColor.red.cgColor
        alert.view.layer.borderWidth = 1
        
        rootController.present(alert, animated: true, completion: nil)
        //TODO: set timer for dismiss
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}









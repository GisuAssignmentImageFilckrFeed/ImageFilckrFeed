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
        // no flshing image for the next list
        self.image = nil
        
        // check cache for image first
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
        if let flickrImageView = (cell as? FeedCell)?.contentImageView {
            flickrImageView.addSubview(flickrImageView.activityIndicator)
            flickrImageView.activityIndicator.centerYAnchor.constraint(equalTo: flickrImageView.centerYAnchor).isActive = true
            flickrImageView.activityIndicator.centerXAnchor.constraint(equalTo: flickrImageView.centerXAnchor).isActive = true
        }
    }
}

extension UIViewController {
    func alertMessage(message : String, rootController : UIViewController) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = UIColor.black
        alert.view.tintColor = UIColor.black
        let messageAttributed = NSMutableAttributedString(
            string: alert.message!,
            attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 19),
                         NSAttributedStringKey.foregroundColor: UIColor.white])
        alert.setValue(messageAttributed, forKey: "attributedMessage")
        
        rootController.present(alert, animated: true, completion: nil)
        //TODO: set timer for dismiss
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700)) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func estimateWidthAndHeightFor(text: String, attributes: [NSAttributedStringKey: Any]) -> CGSize {
        return (text as NSString).size(withAttributes: attributes)
    }
}


public func setupConstraintsForView(view: UIView,
                                    customCenterXAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
                                    customCenterYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
                                    customWidthAnchor: NSLayoutAnchor<NSLayoutDimension>    ,
                                    customHeightAnchor: NSLayoutAnchor<NSLayoutDimension>   ,
                                    rateOfWidth: CGFloat                                    ,
                                    reateOfHeight: CGFloat) {
    view.translatesAutoresizingMaskIntoConstraints = false
    [
        view.centerXAnchor.constraint(equalTo: customCenterXAnchor),
        view.centerYAnchor.constraint(equalTo: customCenterYAnchor),
        view.widthAnchor.constraint(equalTo: customWidthAnchor as! NSLayoutDimension, multiplier: rateOfWidth),
        view.heightAnchor.constraint(equalTo: customHeightAnchor as! NSLayoutDimension, multiplier: reateOfHeight)
    ].forEach{ $0.isActive = true }
}











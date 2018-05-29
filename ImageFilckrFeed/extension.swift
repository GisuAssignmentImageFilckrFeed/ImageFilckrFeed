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
                    self.image = compressedImage
                }
            }
        }
        dataTask.resume()
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
}




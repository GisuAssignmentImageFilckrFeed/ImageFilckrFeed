//
//  FeedController_feedCell.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-30.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit
import MessageUI

// feed cell

extension FeedController {
    func openSelectedImageInbrowser(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            alertMessage(message: "Cannot find the selected Url", rootController: self)
        }
    }
    
    func saveImageToLibrary(flickrImageView: ImageViewWithActivityIndicator) {
        if let image = flickrImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            alertMessage(message: "Saved selected image to Photo Gallery", rootController: self)
        }
    }
    
    func handleImageTapped(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? FeedCell {
            if let image                    = cell.contentImageView.image,
                let compressedImageData     = UIImageJPEGRepresentation(image, 1) {
                
                let source          = CGImageSourceCreateWithData(compressedImageData as CFData, nil)
                let imageMetadata   = CGImageSourceCopyPropertiesAtIndex(source!, 0, nil)
                setupImageMetadataLauncherWith(imageMetadata: imageMetadata!, image: image)
                
            }
        }
    }
    
    func setupImageMetadataLauncherWith(imageMetadata: NSDictionary, image: UIImage) {
        let imageMetadataLauncher               = ImageMetadataLauncher()
        imageMetadataLauncher.metadata          = imageMetadata
        imageMetadataLauncher.transparentView   = setupTransparentView()
        imageMetadataLauncher.setupImageMetadataLauncher(image: image)
    }
    
    func setupTransparentView() -> UIView {
        transparentView                             = UIView()
        transparentView?.backgroundColor            = UIColor.black.withAlphaComponent(0.5)
        transparentView?.isUserInteractionEnabled   = true
        transparentView?.addGestureRecognizer(UITapGestureRecognizer(target: self                                 ,
                                                                     action: #selector(handleDismissImageLauncher)))
        
        return transparentView!
    }
    
    @objc func handleDismissImageLauncher()  {
        UIView.animate(withDuration: 0.3        ,
                       delay: 0                 ,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1 ,
                       options: .curveEaseOut   ,
                       animations: {
                        
            self.transparentView?.frame = CGRect(x: 0                           ,
                                                 y: self.view.frame.height      ,
                                                 width: self.view.frame.width   ,
                                                 height: self.view.frame.height)
        }) { (completed) in
            if completed {
                self.transparentView?.removeFromSuperview()
            }
        }
    }
}

// mail composer

extension FeedController: MFMailComposeViewControllerDelegate {
    //dismiss mailComposer
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendPictureByEmailWith(image : UIImage) {
        if MFMailComposeViewController.canSendMail() {
            let mail                    = MFMailComposeViewController()
            mail.mailComposeDelegate    = self;
            let imageData: Data         = UIImagePNGRepresentation(image)!
            mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "imageName.png")
            self.present(mail, animated: true, completion: nil)
        }
    }
}








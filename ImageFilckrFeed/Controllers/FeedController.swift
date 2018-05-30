//
//  ViewController.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-28.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit
import MessageUI

/*
 Requirements
 • Use the most recent tools for the platform of your choice (iOS – Swift/Xcode or Android - Java /Android Studio or Android Java/Kotlin/Android Studio)            check
 • Limit your usage of 3rd party libraries only to the few ones that add a large benefit to the architecture and testability of the project.    no library used
 • Flickr url that should be used is: https://www.flickr.com/services/feeds/docs/photos_public      check
 • Image metadata should be visible for each picture
 • Git should be used as version control and to track the application development                   check
 
 optional
 • Search for images by tag
 • Image caching                            check
 • Order by date taken or date published    check
 • Save image to the System Gallery         check
 • Open image in system browser             check
 • Share picture by email                   check
 */

class FeedController: UIViewController {
    var mainView            : MainView?
    // XML element detector
    var currentElementName  : String?
    // an array of feeds
    var feeds               : [Feed]?
    
    var rightBarButton      : UIButton?
    var searchBar           : UISearchBar?
    var tags                : [String]?
    let tagCell             = "tagCell"
    var tagCollectionBoardHeightAnchor : NSLayoutConstraint?
    var currentLineSumOfTags : CGFloat = 0.0
    var blackView           : UIView?
    
    lazy var tagCollectionBoard  : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(TagCell.self, forCellWithReuseIdentifier: tagCell)
        cv.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        return cv
    }()
    
    lazy var sortMethodSegmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["date Taken", "date Published"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSortChange), for: .valueChanged)
        
        return sc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        sortFeedsBy("date taken")
        mainView?.feedCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feeds = [Feed]()
        
        setupNavigationBar()
        
        setupMainView()
        
        fetchData()
    }

    func setupNavigationBar() {
        // search button
        rightBarButton = UIButton()
        rightBarButton?.setImage(UIImage(named: "magnifier")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightBarButton?.addTarget(self, action: #selector(handleSearchByTags), for: .touchUpInside)
        rightBarButton?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton!)
        
        // a segmentController
        navigationItem.titleView = sortMethodSegmentedControl
    }
    
    func setupMainView() {
        mainView = MainView()
        mainView?.feedController = self
        
        view.addSubview(mainView!)
        mainView?.translatesAutoresizingMaskIntoConstraints = false
        [
            mainView?.topAnchor.constraint(equalTo: view.topAnchor),
            mainView?.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView?.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainView?.heightAnchor.constraint(equalTo: view.heightAnchor)
        ].forEach{ $0?.isActive = true }
    }
    
    func fetchData() {
        let xmlLauncher = XMLLauncher()
        xmlLauncher.feedController = self
        xmlLauncher.createXMLParser(urlString: "https://api.flickr.com/services/feeds/photos_public.gne")
    }
}

// feed cell

extension FeedController: MFMailComposeViewControllerDelegate {
    func openSelectedImageInbrowser(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func saveImageToLibrary(flickrImageView: ImageViewWithActivityIndicator) {
        if let image = flickrImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            alertMessage(message: "Saved selected image to Photo Gallery", rootController: self)
        }
    }
    
    func sendPictureByEmail(flickrImageView : ImageViewWithActivityIndicator) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self;
            mail.setMessageBody("Write a message here", isHTML: false)
            let imageData: Data = UIImagePNGRepresentation(flickrImageView.image!)!
            mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "imageName.png")
            self.present(mail, animated: true, completion: nil)
        }
    }
    
    func handleTapped(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? FeedCell {
            if let image = cell.flickrImageView.image, let compressedImageData = UIImageJPEGRepresentation(image, 1) {
                let source = CGImageSourceCreateWithData(compressedImageData as CFData, nil)
                let imageMetadata = CGImageSourceCopyPropertiesAtIndex(source!, 0, nil)

                setupImageLauncherWithMetadata(imageMetadata: imageMetadata!, image: image)
            }
        }
    }
    
    func setupImageLauncherWithMetadata(imageMetadata: NSDictionary, image: UIImage) {
        let imageLauncher = ImageLauncher()
        setupBlackView()
        imageLauncher.metadata = imageMetadata
        imageLauncher.blackView = blackView
        imageLauncher.setupImageLauncher(image: image)
    }
    
    func setupBlackView() {
        blackView = UIView()
        blackView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackView?.isUserInteractionEnabled = true
        blackView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissImageLauncher)))
    }
    
    @objc func handleDismissImageLauncher()  {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView?.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }) { (completed) in
            if completed {
                self.blackView?.removeFromSuperview()
            }
        }
    }
}

// navigation bar

extension FeedController {
    @objc func handleSortChange() {
        if sortMethodSegmentedControl.selectedSegmentIndex == 0 {
            // sort by date taken
            sortFeedsBy("date taken")
        } else if sortMethodSegmentedControl.selectedSegmentIndex == 1 {
            // sort by date published
            sortFeedsBy("date published")
        }
        
        mainView?.feedCollectionView.reloadData()
    }
    
    func sortFeedsBy(_ sortingMethod: String) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if sortingMethod == "date taken" {
            feeds?.sort(by: { (feed1, feed2) -> Bool in
                return  dateFormat.date(from: feed1.dateTaken!)! > dateFormat.date(from: feed2.dateTaken!)!
            })
        } else {
            feeds?.sort(by: { (feed1, feed2) -> Bool in
                return  dateFormat.date(from: feed1.publishedDate!)! > dateFormat.date(from: feed2.publishedDate!)!
            })
        }
    }
}

















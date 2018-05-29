//
//  ViewController.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-28.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

/*
 Requirements
 • Use the most recent tools for the platform of your choice (iOS – Swift/Xcode or Android - Java /Android Studio or Android Java/Kotlin/Android Studio)
 • Limit your usage of 3rd party libraries only to the few ones that add a large benefit to the architecture and testability of the project.
 • Flickr url that should be used is: https://www.flickr.com/services/feeds/docs/photos_public
 • Image metadata should be visible for each picture
 • Git should be used as version control and to track the application development
 
 optional
 • Search for images by tag
 • Image caching
 • Order by date taken or date published
 • Save image to the System Gallery
 • Open image in system browser
 • Share picture by email
 */

class FeedController: UIViewController {
    var mainView            : MainView?
    var currentElementName  : String?
    var feeds               : [Feed]?
    
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
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "magnifier")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleSearchByTag))
        rightBarButton.tintColor = .white
        
        navigationItem.titleView = sortMethodSegmentedControl
        navigationItem.rightBarButtonItem = rightBarButton
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
    
    @objc func handleSearchByTag() {
        
    }
    
}

















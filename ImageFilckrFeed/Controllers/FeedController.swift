//
//  ViewController.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-28.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class FeedController: UIViewController {
    var mainView            : MainView?
    // XML element detector
    var currentElementName  : String?
    // an array of feeds
    var feeds               : [Feed]?
    
    let tagCell             = "tagCell"
    
    // UI componenets for navigationBar
    
    var rightBarButton      : UIButton?
    
    lazy var sortMethodSegmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["date Taken", "date Published"])
        sc.addTarget(self, action: #selector(handleSortChange), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints    = false
        sc.tintColor                                    = UIColor.white
        sc.selectedSegmentIndex                         = 0
        
        return sc
    }()
    
    // UI components for search function
    
    var searchBar           : UISearchBar?
    
    var tags                : [String]?
    
    var tagCollectionBoardHeightAnchor : NSLayoutConstraint?
    // a containerView when image get clicked
    var transparentView      : UIView?
    // to detect adding a new line
    var currentLineSumOfTags : CGFloat = 0.0
    
    lazy var tagCollectionBoard  : UICollectionView = {
        let layout          = UICollectionViewFlowLayout()
        let cv              = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource       = self
        cv.delegate         = self
        cv.backgroundColor  = UIColor.black.withAlphaComponent(0.5)
        cv.contentInset     = UIEdgeInsetsMake(8, 0, 0, 0)
        cv.register(TagCell.self, forCellWithReuseIdentifier: tagCell)
        
        return cv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        // setup for default setting by date taken
        sortFeedsBy("date taken")
        mainView?.feedCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feeds = [Feed]()
        
        setupNavigationBar()
        
        setupMainView()
        
        fetchFeeds()
    }

    func setupNavigationBar() {
        // search button
        rightBarButton = UIButton()
        rightBarButton?.setImage(UIImage(named: "magnifier")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightBarButton?.addTarget(self, action: #selector(handleSearchByTags), for: .touchUpInside)
        rightBarButton?.tintColor           = .white
        navigationItem.rightBarButtonItem   = UIBarButtonItem(customView: rightBarButton!)
        
        // a segmentController
        navigationItem.titleView            = sortMethodSegmentedControl
    }
    
    fileprivate func setupMainView() {
        mainView                    = MainView()
        mainView?.feedController    = self
        
        view.addSubview(mainView!)
        setupConstraintsForView(view: mainView!                         ,
                                customCenterXAnchor: view.centerXAnchor ,
                                customCenterYAnchor: view.centerYAnchor ,
                                customWidthAnchor: view.widthAnchor     ,
                                customHeightAnchor: view.heightAnchor   ,
                                rateOfWidth: 1                          ,
                                reateOfHeight: 1)
    }
    
    fileprivate func fetchFeeds() {
        let xmlLauncher             = XMLLauncher()
        xmlLauncher.feedController  = self
        xmlLauncher.createXMLParser(urlString: "https://api.flickr.com/services/feeds/photos_public.gne")
    }
}

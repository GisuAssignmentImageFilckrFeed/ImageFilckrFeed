//
//  MainView.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-28.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class ImageViewWithActivityIndicator: UIImageView {
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        return ai
    }()
}

class MainView: UIView {
    weak var feedController : FeedController?
    let feedCell = "feedCell"
    
    lazy var feedCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(FeedCell.self, forCellWithReuseIdentifier: feedCell)
        cv.showsVerticalScrollIndicator = false
        
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(feedCollectionView)
        feedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        [
            feedCollectionView.topAnchor.constraint(equalTo: topAnchor),
            feedCollectionView.leftAnchor.constraint(equalTo: leftAnchor),
            feedCollectionView.widthAnchor.constraint(equalTo: widthAnchor),
            feedCollectionView.heightAnchor.constraint(equalTo: heightAnchor)
        ].forEach{ $0.isActive = true }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedController?.feeds?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCell, for: indexPath) as! FeedCell
        setupCell(cell: cell, indexPath: indexPath)
        setupActivityIndicator(cell: cell)
        
        return cell
    }
    
    func setupCell(cell: FeedCell, indexPath: IndexPath) {
        cell.feedController = feedController
        cell.feed = feedController?.feeds![indexPath.item]
        cell.profileImageView.layer.cornerRadius = self.frame.width * 0.25 / 4
        cell.flickrImageView.loadImageUsingCacheWithUrlString(urlString: (feedController?.feeds![indexPath.item].imageUrlString)!)
        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: (feedController?.feeds![indexPath.item].author?.profileImageUrlString)!)
        cell.authorLabel.text = feedController?.feeds![indexPath.item].author?.name 
        print((feedController?.feeds![indexPath.item].publishedDate)!)
        cell.dateLabel.text = formatDate(dateString: (feedController?.feeds![indexPath.item].flickrDate)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2, height: 300)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}











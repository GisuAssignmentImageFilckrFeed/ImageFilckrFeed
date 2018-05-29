//
//  FeedCell.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-28.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    let flickrImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.image = UIImage(named: "moviePost2")
        
        return imageView
    }()
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.image = UIImage(named: "moviePost2")
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "Mar 2018"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        
        return label
    }()
    
    let authorLabel : UILabel = {
        let label = UILabel()
        label.text = "Gisu Kim"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(flickrImageView)
        flickrImageView.translatesAutoresizingMaskIntoConstraints = false
        [
            flickrImageView.topAnchor.constraint(equalTo: topAnchor),
            flickrImageView.leftAnchor.constraint(equalTo: leftAnchor),
            flickrImageView.widthAnchor.constraint(equalTo: widthAnchor),
            flickrImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75)
        ].forEach{ $0.isActive = true }
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        [
            containerView.topAnchor.constraint(equalTo: flickrImageView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25)
        ].forEach{ $0.isActive = true }
        
        containerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        [
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            profileImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25),
            profileImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25)
            ].forEach{ $0.isActive = true }
        
        containerView.addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        [
            authorLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -15),
            authorLabel.rightAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: -2),
            authorLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            authorLabel.heightAnchor.constraint(equalToConstant: 30)
        ].forEach{ $0.isActive = true }
        
        containerView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        [
            dateLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 15),
            dateLabel.rightAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: -2),
            dateLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            dateLabel.heightAnchor.constraint(equalToConstant: 30)
        ].forEach{ $0.isActive = true }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

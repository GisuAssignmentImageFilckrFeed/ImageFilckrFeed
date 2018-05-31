//
//  FeedCell.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-28.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    weak var feedController : FeedController?
    var feed : Feed?
    
    lazy var saveButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "download")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleDownloadImage), for: .touchUpInside)
        button.tintColor        = .white
        
        return button
    }()
    
    @objc func handleDownloadImage() {
        feedController?.saveImageToLibrary(flickrImageView: contentImageView)
    }
    
    lazy var openBroswerButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "browser"), for: .normal)
        button.addTarget(self, action: #selector(handleOpenInbroswer), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleOpenInbroswer() {
        if let urlString = feed?.imageUrlString {
            feedController?.openSelectedImageInbrowser(urlString: urlString)
        }
    }
    
    lazy var shareButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleShareByEmail), for: .touchUpInside)
        button.tintColor        = .white
        
        return button
    }()
    
    @objc func handleShareByEmail() {
        if let image = contentImageView.image {
            feedController?.sendPictureByEmailWith(image: image)
        }
    }
    
    let contentImageView : ImageViewWithActivityIndicator = {
        let imageView = ImageViewWithActivityIndicator()
        imageView.backgroundColor   = .gray
        imageView.image             = UIImage(named: "moviePost2")
        
        return imageView
    }()
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor   = .white
        imageView.clipsToBounds     = true
        
        return imageView
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.font          = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        
        return label
    }()
    
    let authorLabel : UILabel = {
        let label = UILabel()
        label.font          = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentImageView)
        setupConstraintsForContainer(view: contentImageView     ,
                                     customTopAnchor: topAnchor ,
                                     rateOfHeight: 0.75)

        addSubview(saveButton)
        setupConstraintsForButton(button: saveButton            ,
                                  customTopAnchor: topAnchor    ,
                                  customRightAnchor: rightAnchor,
                                  topConstant: 8                ,
                                  rightConstant: -16)
        
        addSubview(openBroswerButton)
        setupConstraintsForButton(button: openBroswerButton                 ,
                                  customTopAnchor: saveButton.bottomAnchor  ,
                                  customRightAnchor: rightAnchor            ,
                                  topConstant: 8                            ,
                                  rightConstant: -16)
        
        addSubview(shareButton)
        setupConstraintsForButton(button: shareButton                               ,
                                  customTopAnchor: openBroswerButton.bottomAnchor   ,
                                  customRightAnchor: rightAnchor                    ,
                                  topConstant: 8                                    ,
                                  rightConstant: -14)
        
        addSubview(containerView)
        setupConstraintsForContainer(view: containerView                            ,
                                     customTopAnchor: contentImageView.bottomAnchor ,
                                     rateOfHeight: 0.25)
        
        containerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        [
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            profileImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25),
            profileImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25)
        ].forEach{ $0.isActive = true }
        
        containerView.addSubview(authorLabel)
        setupConstraintsForLabel(label: authorLabel                                 ,
                                 customCenterXAnchor: containerView.centerYAnchor   ,
                                 customRightAnchor: profileImageView.leftAnchor     ,
                                 centerXConstant: -15                               ,
                                 rightConstant: -2)

        containerView.addSubview(dateLabel)
        setupConstraintsForLabel(label: dateLabel                                   ,
                                 customCenterXAnchor: containerView.centerYAnchor   ,
                                 customRightAnchor: profileImageView.leftAnchor     ,
                                 centerXConstant: 15                                ,
                                 rightConstant: -2)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// setup constraints

extension FeedCell {
    fileprivate func setupConstraintsForButton(button: UIButton                                         ,
                                               customTopAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>     ,
                                               customRightAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>   ,
                                               topConstant: CGFloat,
                                               rightConstant: CGFloat) {
        button.translatesAutoresizingMaskIntoConstraints = false
        [
            button.topAnchor.constraint(equalTo: customTopAnchor, constant: topConstant),
            button.rightAnchor.constraint(equalTo: customRightAnchor, constant: rightConstant),
            button.widthAnchor.constraint(equalToConstant: 24),
            button.heightAnchor.constraint(equalToConstant: 24)
            ].forEach{ $0.isActive = true }
    }
    
    fileprivate func setupConstraintsForLabel(label: UILabel                                            ,
                                              customCenterXAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>  ,
                                              customRightAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>    ,
                                              centerXConstant: CGFloat                                  ,
                                              rightConstant: CGFloat) {
        label.translatesAutoresizingMaskIntoConstraints = false
        [
            label.centerYAnchor.constraint(equalTo: customCenterXAnchor, constant: centerXConstant),
            label.rightAnchor.constraint(equalTo: customRightAnchor, constant: rightConstant),
            label.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            label.heightAnchor.constraint(equalToConstant: 30)
            ].forEach{ $0.isActive = true }
    }
    
    fileprivate func setupConstraintsForContainer(view: UIView                                          ,
                                                  customTopAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>  ,
                                                  rateOfHeight: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        [
            view.topAnchor.constraint(equalTo: customTopAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: rateOfHeight)
            ].forEach{ $0.isActive = true }
    }
}

//
//  ImageLauncher.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-30.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

extension ImageMetadataBoard: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: imageMetadataCell, for: indexPath)
        setupCell(cell: cell)
        formatMetadata(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func setupCell(cell: UITableViewCell) {
        cell.textLabel?.textAlignment   = .center
        cell.textLabel?.textColor       = .white
        cell.backgroundColor            = UIColor.black.withAlphaComponent(0.7)
    }
    
    func formatMetadata(cell: UITableViewCell, indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let demension = metadata!["{Exif}"] as? NSDictionary {
                if let pixelXDimension = demension["PixelXDimension"], let pixelYDimension = demension["PixelYDimension"] {
                    cell.textLabel?.text = "Dimension: \(pixelXDimension) x \(pixelYDimension)"
                }
            }
        } else if indexPath.row == 1 {
            if let width = metadata!["PixelWidth"] {
                cell.textLabel?.text = "Width: \(width) pixels"
            }
        } else if indexPath.row == 2 {
            if let height = metadata!["PixelHeight"] {
                cell.textLabel?.text = "Height: \(height) pixels"
            }
        } else if indexPath.row == 3 {
            if let depth = metadata!["Depth"] {
                cell.textLabel?.text = "Bit depth: \(depth)"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return frame.height * 0.8 / 4
    }
}

class ImageMetadataBoard: UIView {
    let imageMetadataCell = "imageMetadataCell"
    var metadata : NSDictionary?
    
    let flickrImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .red
        
        return imgView
    }()
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: imageMetadataCell)
        tv.delegate                     = self
        tv.dataSource                   = self
        tv.backgroundColor              = .clear
        tv.alpha                        = 0.7
        tv.separatorStyle               = .none
        
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(flickrImageView)
        setupConstraintsForView(view: flickrImageView,
                                customCenterXAnchor: centerXAnchor  ,
                                customCenterYAnchor: centerYAnchor  ,
                                customWidthAnchor: widthAnchor      ,
                                customHeightAnchor: heightAnchor    ,
                                rateOfWidth: 1                      ,
                                reateOfHeight: 1)
        
        flickrImageView.addSubview(tableView)
        setupConstraintsForView(view: tableView,
                                customCenterXAnchor: centerXAnchor  ,
                                customCenterYAnchor: centerYAnchor  ,
                                customWidthAnchor: widthAnchor      ,
                                customHeightAnchor: heightAnchor    ,
                                rateOfWidth: 0.8                    ,
                                reateOfHeight: 0.8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageMetadataLauncher: NSObject {
    var transparentView : UIView?
    var metadata        : NSDictionary?
    
    func setupImageMetadataLauncher(image: UIImage) {
        if let keywindow = UIApplication.shared.keyWindow {
            keywindow.addSubview(transparentView!)
            setupImageMetadataBoard(image: image)
            showupImageLauncherWithAnimation(keywindow: keywindow)
        }
    }
    
    func showupImageLauncherWithAnimation(keywindow: UIView) {
        transparentView?.frame = CGRect(x: 0                        ,
                                        y: keywindow.frame.height   ,
                                        width: keywindow.frame.width,
                                        height: keywindow.frame.height)
        
        UIView.animate(withDuration: 0.3        ,
                       delay: 0                 ,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1 ,
                       options: .curveEaseOut   ,
                       animations: {
            self.transparentView?.frame = keywindow.frame
        }, completion: nil)
    }
    
    func setupImageMetadataBoard(image: UIImage) {
        let imageMetadataBoard                      = ImageMetadataBoard()
        imageMetadataBoard.metadata                 = metadata
        imageMetadataBoard.flickrImageView.image    = image
        transparentView?.addSubview(imageMetadataBoard)
        setupConstraintsForView(view: imageMetadataBoard                                ,
                                customCenterXAnchor: (transparentView?.centerXAnchor)!  ,
                                customCenterYAnchor: (transparentView?.centerYAnchor)!  ,
                                customWidthAnchor: (transparentView?.widthAnchor)!      ,
                                customHeightAnchor: (transparentView?.widthAnchor)!     ,
                                rateOfWidth: 0.8                                        ,
                                reateOfHeight: 0.8                                      )
    }
}


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
        formMetadata(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func setupCell(cell: UITableViewCell) {
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
    }
    
    func formMetadata(cell: UITableViewCell, indexPath: IndexPath) {
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
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: imageMetadataCell)
        tv.backgroundColor = .clear
        tv.alpha = 0.7
        tv.separatorStyle = .none
        
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(flickrImageView)
        flickrImageView.translatesAutoresizingMaskIntoConstraints = false
        [
            flickrImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            flickrImageView.topAnchor.constraint(equalTo: topAnchor),
            flickrImageView.widthAnchor.constraint(equalTo: widthAnchor),
            flickrImageView.heightAnchor.constraint(equalTo: heightAnchor)
        ].forEach{ $0.isActive = true }
        
        flickrImageView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        [
            tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            tableView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ].forEach{ $0.isActive = true }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageLauncher: NSObject {
    var blackView : UIView?
    var metadata    : NSDictionary?
    
    func setupImageLauncher(image: UIImage) {
        if let keywindow = UIApplication.shared.keyWindow {
            keywindow.addSubview(blackView!)
            setupImageMetadataBoard(image: image)
            showupImageLauncherWithAnimation(keywindow: keywindow)
        }
    }
    
    func showupImageLauncherWithAnimation(keywindow: UIView) {
        blackView?.frame = CGRect(x: 0, y: keywindow.frame.height, width: keywindow.frame.width, height: keywindow.frame.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView?.frame = keywindow.frame
        }, completion: nil)
    }
    
    func setupImageMetadataBoard(image: UIImage) {
        let imageMetadataBoard = ImageMetadataBoard()
        imageMetadataBoard.metadata = metadata
        imageMetadataBoard.flickrImageView.image = image
        blackView?.addSubview(imageMetadataBoard)
        imageMetadataBoard.translatesAutoresizingMaskIntoConstraints = false
        [
            imageMetadataBoard.centerXAnchor.constraint(equalTo: (blackView?.centerXAnchor)!),
            imageMetadataBoard.centerYAnchor.constraint(equalTo: (blackView?.centerYAnchor)!),
            imageMetadataBoard.widthAnchor.constraint(equalTo: (blackView?.widthAnchor)!, multiplier: 0.8),
            imageMetadataBoard.heightAnchor.constraint(equalTo: (blackView?.widthAnchor)!, multiplier: 0.8)
            
        ].forEach{ $0.isActive = true }
    }
}

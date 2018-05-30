//
//  TagCell.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-29.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    let tagLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        [
            tagLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tagLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            tagLabel.widthAnchor.constraint(equalTo: widthAnchor),
            tagLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ].forEach{ $0.isActive = true }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

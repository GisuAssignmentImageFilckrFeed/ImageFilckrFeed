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
        setupConstraintsForView(view: tagLabel                      ,
                                customCenterXAnchor: centerXAnchor  ,
                                customCenterYAnchor: centerYAnchor  ,
                                customWidthAnchor: widthAnchor      ,
                                customHeightAnchor: heightAnchor    ,
                                rateOfWidth: 1                      ,
                                reateOfHeight: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

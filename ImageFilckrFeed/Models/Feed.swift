//
//  Feed.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-28.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class Feed: NSObject {
    var title            : String?
    var id               : String?
    var imageUrlString   : String?
    var publishedDate    : String?
    var updatedDate      : String?
    var flickrDate       : String?
    var dateTaken        : String?
    var author           : Author?
    
    override init() {
        self.title              = TempFeed.title
        self.id                 = TempFeed.id
        self.imageUrlString     = TempFeed.imageUrlString
        self.publishedDate      = TempFeed.publishedDate
        self.updatedDate        = TempFeed.updatedDate
        self.flickrDate         = TempFeed.flickrDate
        self.dateTaken          = TempFeed.dateTaken
    }
}

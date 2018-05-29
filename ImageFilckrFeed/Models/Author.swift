//
//  Author.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-28.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class Author: NSObject {
    var name                     : String?
    var urlString                : String?
    var id                       : String?
    var profileImageUrlString    : String?
    
    override init() {
        self.name                   = TempAuthor.name
        self.urlString              = TempAuthor.urlString
        self.id                     = TempAuthor.id
        self.profileImageUrlString  = TempAuthor.profileImageUrlString
    }
}

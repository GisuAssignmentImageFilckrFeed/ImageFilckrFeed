//
//  ViewController.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-28.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

/*
 Requirements
 • Use the most recent tools for the platform of your choice (iOS – Swift/Xcode or Android - Java /Android Studio or Android Java/Kotlin/Android Studio)
 • Limit your usage of 3rd party libraries only to the few ones that add a large benefit to the architecture and testability of the project.
 • Flickr url that should be used is: https://www.flickr.com/services/feeds/docs/photos_public
 • Image metadata should be visible for each picture
 • Git should be used as version control and to track the application development
 
 optional
 • Search for images by tag
 • Image caching
 • Order by date taken or date published
 • Save image to the System Gallery
 • Open image in system browser
 • Share picture by email
 */

class FeedController: UIViewController {
    
    var mainView            : MainView?
    var currentElementName  : String?
    var feeds               : [Feed]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feeds = [Feed]()
        setupMainView()
        
        // fetch data
        fetchData()
    }
    
    func setupMainView() {
        mainView = MainView()
        mainView?.feedController = self
        
        
        view.addSubview(mainView!)
        mainView?.translatesAutoresizingMaskIntoConstraints = false
        [
            mainView?.topAnchor.constraint(equalTo: view.topAnchor),
            mainView?.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView?.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainView?.heightAnchor.constraint(equalTo: view.heightAnchor)
        ].forEach{ $0?.isActive = true }
    }
    
    
    func fetchData() {
        if let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne") {
            if let parser = XMLParser(contentsOf: url) {
                // delegation to ViewController
                parser.delegate = self
                parser.parse()
            }
        }
    }
}

// XML parser

extension FeedController: XMLParserDelegate {
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElementName = elementName
        
        if elementName == "entry" {
            TempFeed.title                  = ""
            TempFeed.id                     = ""
            TempFeed.publishedDate          = ""
            TempFeed.imageUrlString         = ""
            TempFeed.updatedDate            = ""
            TempFeed.flickrDate             = ""
            TempFeed.dateTaken              = ""
            TempFeed.imageUrlString         = ""
        }
        
        // get image url
        if elementName == "link" {
            if let rel = attributeDict["rel"], rel == "enclosure" , let imageLink = attributeDict["href"]{
                TempFeed.imageUrlString = imageLink
            }
        }
        
        //fetch author
        if elementName == "author" {
            TempAuthor.name                      = ""
            TempAuthor.urlString                 = ""
            TempAuthor.id                        = ""
            TempAuthor.profileImageUrlString     = ""
        }
        
        
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if data.count != 0 {
            switch currentElementName {
            case "title":
                TempFeed.title = data
                fallthrough
            case "id":
                TempFeed.id = data
                fallthrough
            case "published":
                TempFeed.publishedDate = data
                fallthrough
            case "updated":
                TempFeed.updatedDate = data
                fallthrough
            case "flickr:date_taken":
                TempFeed.flickrDate = data
                fallthrough
            case "dc:date.Taken":
                TempFeed.dateTaken = data
                fallthrough
            case "name":
                TempAuthor.name = data
                fallthrough
            case "uri":
                TempAuthor.urlString = data
                fallthrough
            case "flickr:nsid":
                TempAuthor.id = data
                fallthrough
            case "flickr:buddyicon":
                TempAuthor.profileImageUrlString = data
                fallthrough
            default: break
            }
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry" {
            let feed = Feed()
            let author = Author()
            feed.author = author
            feeds?.append(feed)
        }
    }
}


struct TempFeed {
    static var title            : String = ""
    static var id               : String = ""
    static var imageUrlString   : String = ""
    static var publishedDate    : String = ""
    static var updatedDate      : String = ""
    static var flickrDate       : String = ""
    static var dateTaken        : String = ""

}

struct TempAuthor {
    static var name                     : String = ""
    static var urlString                : String = ""
    static var id                       : String = ""
    static var profileImageUrlString    : String = ""
}


























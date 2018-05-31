//
//  XMLParer.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-29.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class XMLLauncher: NSObject, XMLParserDelegate {
    var currentElementName  : String?
    weak var feedController : FeedController?
    
    func createXMLParser(urlString: String) {
        feedController?.feeds = [Feed]()
        feedController?.mainView?.feedCollectionView.reloadData()
        
        if let url = URL(string: urlString) {
            if let parser = XMLParser(contentsOf: url) {
                // delegation to ViewController
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElementName = elementName
        
        if elementName == "entry" {
            clearTempFeed()
        }
        
        // get image url
        if elementName == "link" {
            if let rel = attributeDict["rel"], rel == "enclosure" , let imageLink = attributeDict["href"]{
                TempFeed.imageUrlString = imageLink
            }
        }
        
        // fetch author
        if elementName == "author" {
            clearTempAuthor()
        }
    }
    
    fileprivate func clearTempFeed() {
        TempFeed.title                  = ""
        TempFeed.id                     = ""
        TempFeed.publishedDate          = ""
        TempFeed.imageUrlString         = ""
        TempFeed.updatedDate            = ""
        TempFeed.flickrDate             = ""
        TempFeed.dateTaken              = ""
        TempFeed.imageUrlString         = ""
    }
    
    fileprivate func clearTempAuthor() {
        TempAuthor.name                      = ""
        TempAuthor.urlString                 = ""
        TempAuthor.id                        = ""
        TempAuthor.profileImageUrlString     = ""
    }
    
    // parse data
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if data.count != 0 {
            switch currentElementName {
            case "title":
                TempFeed.title          = data
                fallthrough
            case "id":
                TempFeed.id             = data
                fallthrough
            case "published":
                TempFeed.publishedDate  = data
                fallthrough
            case "updated":
                TempFeed.updatedDate    = data
                fallthrough
            case "flickr:date_taken":
                TempFeed.flickrDate     = data
                fallthrough
            case "dc:date.Taken":
                TempFeed.dateTaken      = data
                fallthrough
            case "name":
                TempAuthor.name         = data
                fallthrough
            case "uri":
                TempAuthor.urlString    = data
                fallthrough
            case "flickr:nsid":
                TempAuthor.id           = data
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
            let feed    = Feed()
            let author  = Author()
            feed.author = author
            feedController?.feeds?.append(feed)
            
            // update UI
            feedController?.mainView?.feedCollectionView.reloadData()
        }
    }
}



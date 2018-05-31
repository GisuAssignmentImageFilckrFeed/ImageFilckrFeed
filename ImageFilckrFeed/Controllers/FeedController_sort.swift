//
//  FeedController_navigation.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-30.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

// sort methods for the toggle button

extension FeedController {
    @objc func handleSortChange() {
        if sortMethodSegmentedControl.selectedSegmentIndex == 0 {
            // sort by date taken
            sortFeedsBy("date taken")
        } else if sortMethodSegmentedControl.selectedSegmentIndex == 1 {
            // sort by date published
            sortFeedsBy("date published")
        }
        
        mainView?.feedCollectionView.reloadData()
    }
    
    func sortFeedsBy(_ sortingMethod: String) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if sortingMethod == "date taken" {
            feeds?.sort(by: { (feed1, feed2) -> Bool in
                return  dateFormat.date(from: feed1.dateTaken!)! > dateFormat.date(from: feed2.dateTaken!)!
            })
        } else {
            feeds?.sort(by: { (feed1, feed2) -> Bool in
                return  dateFormat.date(from: feed1.publishedDate!)! > dateFormat.date(from: feed2.publishedDate!)!
            })
        }
    }
}


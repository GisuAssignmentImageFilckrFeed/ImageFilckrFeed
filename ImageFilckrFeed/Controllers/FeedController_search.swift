//
//  FeedController_search.swift
//  ImageFilckrFeed
//
//  Created by gisu kim on 2018-05-29.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

extension FeedController: UISearchBarDelegate {
    @objc func handleSearchByTags() {
        setupSearch()
        navigationItem.titleView = searchBar
    }
    
    func setupSearch() {
        switchButton(buttonType: "dismiss")
        setupSearchBar()
        setupTagBoard()
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar?.delegate = self
        searchBar?.placeholder = "Add Tags"
    }
    
    func setupTagBoard() {
        clearTagBoard()
        
        view.addSubview(tagCollectionBoard)
        tagCollectionBoard.translatesAutoresizingMaskIntoConstraints = false
        [
            tagCollectionBoard.topAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!),
            tagCollectionBoard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tagCollectionBoard.widthAnchor.constraint(equalTo: view.widthAnchor)
        ].forEach{ $0?.isActive = true }
        tagCollectionBoardHeightAnchor = tagCollectionBoard.heightAnchor.constraint(equalToConstant: 60)
        tagCollectionBoardHeightAnchor?.isActive = true
    }
    
    func clearTagBoard() {
        tags = [String]()
        tagCollectionBoard.reloadData()
    }
    
    @objc func handleDismissSearchBar() {
        searchBar?.removeFromSuperview()
        tagCollectionBoard.removeFromSuperview()
        switchButton(buttonType: "search")
        navigationItem.titleView = sortMethodSegmentedControl
    }
    
    func switchButton(buttonType: String) {
        if buttonType == "search" {
            self.rightBarButton?.setImage(UIImage(named: "magnifier")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.rightBarButton?.addTarget(self, action: #selector(self.handleSearchByTags), for: .touchUpInside)
        } else if buttonType == "dismiss" {
            self.rightBarButton?.setImage(UIImage(named: "dismiss_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.rightBarButton?.addTarget(self, action: #selector(self.handleDismissSearchBar), for: .touchUpInside)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.last == " " {
            let index = searchText.index(searchText.startIndex, offsetBy: searchText.count - 1)
            let typedWord =  searchText[..<index]
            // save a tag
            tags?.append(String(typedWord))
            addNewLineIfNeed()
            // clear textfield
            searchBar.text = ""
            
            tagCollectionBoard.reloadData()
            fetchByTags()
        }
    }
    
    func fetchByTags() {
        var urlString = "https://api.flickr.com/services/feeds/photos_public.gne?tags="
        for tag in tags! {
            if tag == tags?.first {
                urlString += tag
            } else {
                urlString += ",\(tag)"
            }
        }
        
        let xmlLauncher = XMLLauncher()
        xmlLauncher.feedController = self
        xmlLauncher.createXMLParser(urlString: urlString)
    }
    
    func addNewLineIfNeed() {
        let size = estimateWidthAndHeightFor(text: tags![(tags?.count)! - 1], attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        
        // width of current text + extra space for edge + interitemspace
        currentLineSumOfTags += size.width + 8 + 4
        
        if currentLineSumOfTags > view.frame.width {
            tagCollectionBoardHeightAnchor?.constant += 22
            currentLineSumOfTags = size.width + 8
        }
    }
}


extension FeedController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCell, for: indexPath) as! TagCell
        cell.backgroundColor = .orange
        let attributedString = NSAttributedString(string: tags![indexPath.item], attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white])
        cell.tagLabel.attributedText = attributedString
        cell.layer.cornerRadius = 11
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = estimateWidthAndHeightFor(text: tags![indexPath.item], attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white])
        
        return CGSize(width: size.width + 8, height: 22)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}









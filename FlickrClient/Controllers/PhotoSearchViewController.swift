//
//  PhotoSearchViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import UIKit

class PhotoSearchViewController: FlickrCollectionViewController  {
    
    private var searchText = String()
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeybord(_:)))
            tap.cancelsTouchesInView = false
            return tap
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.addGestureRecognizer(tapRecognizer)
        collectionView.keyboardDismissMode = .onDrag
    }
    
    @objc func hideKeybord(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        }
    
    func clearData() {
        flickrItemArray = [FlickrItemCollection]()
        downloadedPages = 1
        collectionView.reloadData()
    }
    
}

extension PhotoSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.searchText = searchText
            query = .searchText(searchText)
            clearData()
            fetchImages(query)
            searchBar.endEditing(true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBarHeader", for: indexPath)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        searchView.becomeFirstResponder()
        return searchView
    }
}


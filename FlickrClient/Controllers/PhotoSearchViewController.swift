//
//  PhotoSearchViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import UIKit

class PhotoSearchViewController: FlickrCollectionViewController  {
    
    private var searchText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func clearData() {
        flickrItemArray = [FlickrItemCollection]()
        downloadedPages = 1
        collectionView.reloadData()
    }
}
extension PhotoSearchViewController: UISearchBarDelegate {
    
    // MARK:    - UISearchBarDelegate
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


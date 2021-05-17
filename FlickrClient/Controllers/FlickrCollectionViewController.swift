//
//  FlickrCollectionViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 16.05.2021.
//
import UIKit
import Foundation

class FlickrCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "PhotoCellIdentifier"
    private let detailViewSegue = "DetailPhotoSearchSegue"
    
    var downloadedPages = 1
    var flickrItemArray = [FlickrItemCollection]()
    var query: QueryType?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func fetchImages(_ queryType: QueryType?) {
        guard let queryType = queryType else {return}
        QueryService.getURLsOfItems(downloadedPages, queryType) { [weak self] (items, error) in
            guard let self = self else {return}
            
            if items != nil && error == nil {
                guard let items = items else { return }
                self.downloadedPages += 1
                for oneItem in items {
                    guard let value = oneItem else { return }
                    self.flickrItemArray.append(value)
                }
                self.collectionView.reloadData()
            } else {
                print("Error: \(String(describing: error))")
            }
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == detailViewSegue {
            if let conroller = segue.destination as? DetailViewController {
                if let indexPath = sender as? IndexPath {
                    conroller.itemImage = flickrItemArray[indexPath.row]
                }
            }
        }
    }
}

extension FlickrCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrItemArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? PhotoCell {
            cell.tag = indexPath.row
            cell.setData(flickrItemArray[indexPath.row], indexPath)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == flickrItemArray.count - 1  {
            fetchImages(query)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if flickrItemArray[indexPath.row].smallPhoto.haveData() {
            performSegue(withIdentifier: detailViewSegue, sender: indexPath)
        }
    }
    
    //     MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3
        return CGSize(width: width - 1, height: width - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1)
        
    }
}

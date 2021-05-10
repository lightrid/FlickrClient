//
//  PhotoSearchViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import UIKit

class PhotoSearchViewController: UIViewController  {
    
    private var flickrItemArray = [FlickrItem]()
    private let reuseIdentifier = "PhotoSearchCell"
    private let searchText = String()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.fetchImages()
    }
     
    func fetchImages() {
        QueryService.getURLsOfItems(flickrItemArray.count, searchText) { [weak self] (items, error) in
            guard let self = self else {return}

            if error == nil {
                guard let items = items else { return }
                for oneItem in items {
                    guard let value = oneItem else { return }
                    self.flickrItemArray.append(value)
                    self.collectionView.reloadData()
                }
        } else {
            print("Error: \(String(describing: error))")
        }
    }
}
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "DetailPhotoSearchSegue" {
            if let conroller = segue.destination as? DetailViewController {
                if let indexPath = sender as? IndexPath {
                    conroller.itemImage = flickrItemArray[indexPath.row]
                    }
                }
            }
        }

}

extension PhotoSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrItemArray.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("init \(indexPath.row)")
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                          for: indexPath) as? PhotoSearchCell{
            self.flickrItemArray[indexPath.row].getPhoto {(data) -> () in
                cell.update(data)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }

     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= flickrItemArray.count - 1  {
            fetchImages()
        }
    }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if flickrItemArray[indexPath.row].haveSmallData() {
            performSegue(withIdentifier: "DetailPhotoSearchSegue", sender: indexPath)
        }
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3
        return CGSize(width: width - 1, height: width - 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1)
        
    }
}

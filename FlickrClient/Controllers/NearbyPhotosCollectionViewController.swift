//
//  NearbyPhotosCollectionViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import UIKit
import FlickrKit

class NearbyPhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var flickrItemArray = [FlickrItem]()
    private let reuseIdentifier = "NearbyPhotoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchImages()
    }
    
    func fetchImages() {
        QueryService.getNearbyURLs(flickrItemArray.count) { [weak self] (urls, error) in
            guard let self = self else {return}
            
            if error == nil {
                guard let URLs = urls else { return }
               
                for url in URLs{
                    if let validURL = url {
                        let item = FlickrItem(url: validURL)
                        self.flickrItemArray.append(item)
                    }
                    self.collectionView.reloadData()
                }
            } else {
                print("Error: \(String(describing: error))")
            }
        }
    }
    


    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrItemArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("init \(indexPath.row)")
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                          for: indexPath) as? NearbyPhotoCell{
            self.flickrItemArray[indexPath.row].getPhoto {(data) -> () in
                cell.update(data)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= flickrItemArray.count - 1  {
            fetchImages()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if flickrItemArray[indexPath.row].haveData() {
            performSegue(withIdentifier: "DetailNearblyPhotoSegue", sender: indexPath)
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
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if  segue.identifier == "DetailNearblyPhotoSegue" {
           if let conroller = segue.destination as? DetailViewController {
               if let indexPath = sender as? IndexPath {
//                 flickrItemArray[indexPath.row].getPhoto({ (data) in
//                    conroller.image = data
//                })
                conroller.image = flickrItemArray[indexPath.row]
               }
           }
       }
    }
    
}


/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
 return true
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
 return true
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
 return false
 }
 
 override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
 return false
 }
 
 override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
 
 }
 */



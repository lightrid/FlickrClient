//
//  NearbyPhotosCollectionViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import UIKit
import FlickrKit

struct FlickrItem {
    var URL: URL
     var photoData: Data?
    var image: UIImage?
    
    init(url: URL) {
        URL = url
    }
    func getPhoto(_ completion: @escaping(_ data: Data) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL) {
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }
    //    mutating func getPhoto() -> Data? {
    //       if let data = try? Data(contentsOf: URL) {
    //        photoData = data
    //         return data
    //       }
    //        return nil
    //   }
    //    func getPhoto(_ completion: @escaping(_ data: Data) -> ()) {
    //        DispatchQueue.global().async {
    //            guard let imageData = try? Data(contentsOf: self.URL) else { return}
    //            DispatchQueue.main.async {
    //                completion(imageData)
    //            }
    //        }
    //    }
}

private let reuseIdentifier = "NearbyPhotoCell"

class NearbyPhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    private var flickrItemArray = [FlickrItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
//        let refreshContrlol = UIRefreshControl()
//        refreshContrlol.addTarget(self, action: #selector(self.fetchImages), for: .valueChanged)
//        //        // Register cell classes
//        self.collectionView.addSubview(refreshContrlol)
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        fetchImages()
        // Do any additional setup after loading the view.
    }
    
     func fetchImages() {
        QueryService.getNearbyURLs(flickrItemArray.count) { [weak self] (urls, error) in
            guard let self = self else {return}
            
            if error == nil {
                guard let URLs = urls else { return }
                //flickrItemArray.append(contentsOf: FlickrItem(url: URLs))
                for url in URLs{
                    let item = FlickrItem(url: url!)
                    self.flickrItemArray.append(item)
                    
                }
                self.collectionView.reloadData()
            } else {
                
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    func urlToImage() {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    //    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 3
    //    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrItemArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearbyPhotoCell.identifier,
                                                          for: indexPath) as? NearbyPhotoCell{
            if let data = flickrItemArray[indexPath.row].photoData  {
                cell.updateCell(image: <#T##UIImage#>)
            } else {
            self.flickrItemArray[indexPath.row].getPhoto { (data) -> () in
                cell.imageData = data
            }
            }
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= flickrItemArray.count - 30 {
            fetchImages()
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



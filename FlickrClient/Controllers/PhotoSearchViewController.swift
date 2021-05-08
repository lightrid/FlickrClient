//
//  PhotoSearchViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import UIKit

class PhotoSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    let identifier = "PhotoSearchCell"
    var photoURLs: [URL?]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.fetchImages()
        // Do any additional setup after loading the view.
    }
     
    func fetchImages() {
        QueryService.getSearchURLs(photoURLs?.count ?? 0) { (urls, error) in
           if error == nil {
               guard let URLs = urls else { return }
            if self.photoURLs == nil {
                self.photoURLs = [URL]()
                self.photoURLs = URLs
            } else {
                self.photoURLs?.append(contentsOf: URLs)
            }
               
               self.collectionView.reloadData()
           } else {
              
               print("Error: \(String(describing: error))")
           }
       }
   }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoURLs?.count ?? 0
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSearchCell.identifier, for: indexPath) as! PhotoSearchCell
        
       
        cell.photoURL = self.photoURLs?[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1)

    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= (photoURLs?.count ?? 10) - 10 {
          //  fetchImages()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

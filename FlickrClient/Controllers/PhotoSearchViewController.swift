//
//  PhotoSearchViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import UIKit

class PhotoSearchViewController: UIViewController {

    let identifier = "PhotoSearchCell"
    var photoURLs: [URL?]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchImages()
        // Do any additional setup after loading the view.
    }
     
    func fetchImages() {
       QueryService.getExprole(sender: self) { (urls, error) in
           if error == nil {
               guard let URLs = urls else { return }
               self.photoURLs = [URL]()
               self.photoURLs = URLs
               self.collectionView.reloadData()
           } else {
              
               print("Error: \(String(describing: error))")
           }
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

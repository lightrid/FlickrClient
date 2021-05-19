//
//  PhotoSearchCell.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 08.05.2021.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! 
    
    private var completion: ((Data?)-> Void)?
    
    func setData(_ item: FlickrItemCollection, _ index: IndexPath)  {
        completion = { [weak self] (data) in
            guard let self = self else {
                return
            }
            
            guard let data = data else {
                self.displayData(.none)
                return
            }
            
            if self.tag == index.row { 
                self.displayData(data)
            }
        }
        item.smallPhoto.getPhoto(completion)
    }
    
    func displayData(_ flickrItemData: Data?) {
        if let flickrItemData = flickrItemData {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.imageView.isHidden = false
            imageView.image = UIImage(data: flickrItemData)
        } else {
            imageView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    
}

//
//  NearbyPhotoCell.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 06.05.2021.
//

import UIKit

class NearbyPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var completion: ((Data?)-> Void)?
    
    func setData(_ item: FlickrItemCollection)  {
        completion = { [weak self] (data) in
            guard let self = self else { return }
            if let data = data {
                self.displayData(data)
            } else {
                self.displayData(.none)
            }
        }
        item.smallPhoto.getPhoto(completion)
    }
    
    //TODO: Зупинка загруки фото
    override func prepareForReuse() { // Зараз працює не коректно. (в іншому конролері зроблено через тег)
        cancelCompletion()
        displayData(.none)
    }
    
    func cancelCompletion() {
        completion = nil
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

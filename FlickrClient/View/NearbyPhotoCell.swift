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
    
    public func update(_ data: Data?) {
        if let data = data {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = UIImage()
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
        }
    }
}


//
//  NearbyPhotoCell.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 06.05.2021.
//


import UIKit


class NearbyPhotoCell: UICollectionViewCell {
    
    static let identifier = "NearbyPhotoCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    func updateCell(image: UIImage) {
        imageView.image = image
    }
}


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
    
    var photoURL: URL? {
        didSet {
            DispatchQueue.global().async {
                guard let imageUrl = self.photoURL else {return}
                guard let imageData = try? Data(contentsOf: imageUrl) else { return}
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        }
    }
}

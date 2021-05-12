//
//  PhotoSearchCell.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 08.05.2021.
//

import Foundation
import UIKit

class PhotoSearchCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    
    func clearImage() {
        imageView.image = UIImage()
    }
    
    func setData(_ item: FlickrItem)  {
        //get foto
    }
    public func update(_ data: Data?,_ indexPath: IndexPath) {
        label.text = String(indexPath.row)
        if let data = data {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            imageView.isHidden = false
            imageView.image = UIImage(data: data)
        } else {
            imageView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
}

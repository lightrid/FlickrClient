//
//  PhotoSearchCell.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 08.05.2021.
//

import Foundation
import UIKit

class PhotoSearchCell: UICollectionViewCell {
    
    static let identifier = "PhotoSearchCell"

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

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
    
    var flickrItemData: Data?
    private var completion: ((Data?)->())?
    

    func setData(_ item: FlickrItemCollection)  {
        completion = { [weak self] (data) in
            guard let self = self else { return }
            if let data = data {
//                self.updateCell(data)
                self.displayData(data)
            } else {
                self.displayData(.none)
            }
        }
        item.smallPhoto.getPhoto(completion!)
    }
    override func prepareForReuse() {
        //displayData(.none)
        DispatchQueue.main.async {
            self.cancelCompletion()
            self.displayData(.none)
        }
        //cancelCompletion()
//        clearImage()
//        waitForData()
    }
    
    
    func cancelCompletion() {
        completion = nil
    }
    
     func displayData(_ flickrItemData: Data?) {
        self.flickrItemData = flickrItemData
        if let flickrItemData = self.flickrItemData {
            label.text = "Have"
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.imageView.isHidden = false
            imageView.image = UIImage(data: flickrItemData)
        } else {
            label.text = "Wait"
            imageView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    func clearImage() {
        imageView.image = nil
    }
    func updateCell(_ data: Data) {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.imageView.isHidden = false
        imageView.image = UIImage(data: data)
    }
    
    func waitForData() {
        label.text = "Wait"
        imageView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    public func update(_ data: Data?,_ indexPath: IndexPath) {
        label.text = String(indexPath.row)
        if let data = data {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            imageView.isHidden = false
            imageView.image = UIImage(data: data)
        } else {
            
        }
    }
}

//
//  DetailViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: FlickrItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image?.getPhoto({ (data) in
            if let data = data {
                self.imageView.image = UIImage(data: data)
            }
        })
//        if let data = imageData {
//            imageView.image = UIImage(data: data)
//        }
    
    }
    
    func fetchImage() {
        QueryService.getFullPhoto(image?.URL) {[weak self]  (url, error) in
            guard let self = self else { return }
            
            if error == nil {
                guard let url = url else { return }
                self.image?.getFullViewPhoto({ (data) in
                    if let data = data {
                        self.imageView.image = UIImage(data: data)
                    }
                })
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

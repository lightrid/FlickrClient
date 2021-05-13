//
//  DetailViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//
import UIKit

class DetailViewController: UIViewController {
    
//    TODO: Зум в конкретну точку.
//    Межі зображення при зумі

    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!

    var itemImage: FlickrItemCollection?
    var currentImage: UIImage?
    
    lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        return doubleTap
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        scrollViewSettings()
        fetchImage()
    }

    func scrollViewSettings() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }
    
    func fetchImage() {
        activityIndicator.startAnimating()
    
        itemImage?.smallPhoto.getPhoto({ (data) in
            if let data = data {
                self.imageView.image = UIImage(data: data)
            }
        })
        
        itemImage?.largePhoto.getPhoto({ (data) in
            if let data = data {
                self.currentImage = UIImage(data: data)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.setScrollViewImage(image: self.currentImage ?? UIImage())
            }
        })
    }
    
    func setScrollViewImage(image: UIImage) {
        imageView.removeFromSuperview()
        imageView = nil
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
             ])
    }
    
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.setZoomScale(2, animated: true)
            } else {
                scrollView.setZoomScale(1, animated: true)
            }
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

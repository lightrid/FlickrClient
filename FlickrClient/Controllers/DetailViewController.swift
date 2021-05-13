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
//    Забрати нижні таби на контроллері
    
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



//
//import UIKit
//
//class PanZoomImageView: UIScrollView {
//
//    @IBInspectable
//    private var imageName: String? {
//        didSet {
//            guard let imageName = imageName else {
//                return
//            }
//            imageView.image = UIImage(named: imageName)
//        }
//    }
//    private let imageView = UIImageView()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        commonInit()
//    }
//
//    convenience init(named: String) {
//        self.init(frame: .zero)
//        self.imageName = named
//    }
//
//    private func commonInit() {
//        // Setup image view
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
//        addSubview(imageView)
//        NSLayoutConstraint.activate([
//            imageView.widthAnchor.constraint(equalTo: widthAnchor),
//            imageView.heightAnchor.constraint(equalTo: heightAnchor),
//            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//
//        // Setup scroll view
//        minimumZoomScale = 1
//        maximumZoomScale = 3
//        showsHorizontalScrollIndicator = false
//        showsVerticalScrollIndicator = false
//        delegate = self
//    }
//
//}
//
//extension PanZoomImageView: UIScrollViewDelegate {
//
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//
//}
//
//class DetailViewController: UIViewController {
//
//    @IBOutlet weak var imageView: UIImageView!
//
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//
//    var smallImage: UIImage?
//    var largeImage: FlickrItem?
//
//    var panGesture  = UIPanGestureRecognizer()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        activityIndicator.startAnimating()
//        largeImage?.getPhoto({ (data) in
//            if let data = data {
//                self.imageView.image = UIImage(data: data)
//            }
//        })
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.dragImg(_:)))
//        imageView.isUserInteractionEnabled = true
//
//        largeImage?.getFullViewPhoto({ (data) in
//            if let data = data {
//                self.imageView.image = UIImage(data: data)
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
//                self.imageView.addGestureRecognizer(self.panGesture)
//            }
//        })
//
//
//
//    }
//    func fetchImage() {
//
//    }
//    deinit {
//        print("hi")
//    }
//
//    @objc func dragImg(_ sender:UIPanGestureRecognizer){
//        let translation = sender.translation(in: self.view)
//        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
//        sender.setTranslation(CGPoint.zero, in: self.view)
//    }
//
//    @IBAction func scaleImg(_ sender: UIPinchGestureRecognizer) {
//        imageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
//    }
//
//    //    func fetchImage() {
//    //        QueryService.getFullPhoto(image?.URL) {[weak self]  (url, error) in
//    //            guard let self = self else { return }
//    //            if error == nil {
//    //                guard let url = url else { return }
//    //                self.image?.getFullViewPhoto({ (data) in
//    //                    if let data = data {
//    //                        self.imageView.image = UIImage(data: data)
//    //                    }
//    //                })
//    //            }
//    //
//    //        }
//    //    }
//
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destination.
//     // Pass the selected object to the new view controller.
//     }
//     */
//
//}


//  DetailViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

//import UIKit
//
//class DetailViewController: UIViewController {
//
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var scrollView: UIScrollView!
//
//    var smallImage: UIImage?
//    var largeImage: FlickrItem?
//
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        scrollView.maximumZoomScale = 4
//        scrollView.minimumZoomScale = 1
//
//
//        activityIndicator.startAnimating()
//        largeImage?.getPhoto({ (data) in
//            if let data = data {
//                self.imageView.image = UIImage(data: data)
//            }
//        })
//
//        largeImage?.getFullViewPhoto({ (data) in
//            if let data = data {
//                self.imageView.image = UIImage(data: data)
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
//
//            }
//        })
//
//        scrollView.delegate = self
//
//    }
//
//
//
//
//}
//extension DetailViewController: UIScrollViewDelegate {
//
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        if scrollView.zoomScale > 1 {
//            if let image = imageView.image {
//                let ratioW = imageView.frame.width / image.size.width
//                let ratioH = imageView.frame.height / image.size.height
//
//                let ratio = ratioW < ratioH ? ratioW : ratioH
//                let newWidth = image.size.width * ratio
//                let newHeight = image.size.height * ratio
//                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
//                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
//                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
//
//                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
//
//                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
//
//            }
//        } else {
//            scrollView.contentInset = .zero
//        }
//    }
//
//}



//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        self.centerImage()
//    }



//import UIKit
//
//class DetailViewController: UIViewController {
//
//    @IBOutlet var imageView: UIImageView!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var scrollView: UIScrollView!
//
//    var smallImage: UIImage?
//    var largeImage: FlickrItem?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
//        scrollView.delegate = self
//
//        activityIndicator.startAnimating()
//        largeImage?.getPhoto({ (data) in
//            if let data = data {
//                self.imageView.image = UIImage(data: data)
//            }
//        })
//
//        largeImage?.getFullViewPhoto({ (data) in
//            if let data = data {
//                self.smallImage = UIImage(data: data)
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
//                self.set(image: self.smallImage ?? UIImage())
//
//            }
//        })
//
//
//
//
//    }
//
//
//
//
//}
//extension DetailViewController: UIScrollViewDelegate {
//
//    func set(image: UIImage) {
//        imageView.removeFromSuperview()
//        imageView = nil
//        imageView = UIImageView(image: smallImage)
//        scrollView.addSubview(imageView)
//
//        configurateFor(imageSize: image.size)
//    }
//
//    func configurateFor(imageSize: CGSize) {
//        scrollView.contentSize = imageSize
//    }
//
//}

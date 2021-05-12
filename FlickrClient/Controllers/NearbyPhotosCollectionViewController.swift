//
//  NearbyPhotosCollectionViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import UIKit
import FlickrKit
import CoreLocation

class NearbyPhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var flickrItemArray = [FlickrItem]()
    private let reuseIdentifier = "NearbyPhotoCell"
    private var locationManager =  CLLocationManager()
    private var curentLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        checkLocation()
        
    }
    
    func checkLocation() {
        curentLocation = locationManager.location
        fetchImages()
    }
    func fetchImages() {
        guard let location = curentLocation else {return}
        QueryService.getURLsOfItems(flickrItemArray.count, .userLocation(location)) { [weak self] (items, error) in
            guard let self = self else {return}
            if items != nil || error == nil {
                guard let items = items else { return }
                for oneItem in items {
                    guard let value = oneItem else { return }
                    self.flickrItemArray.append(value)
                    self.collectionView.reloadData()
                }
            } else {
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrItemArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("init \(indexPath.row)")
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? NearbyPhotoCell{
            cell.imageView.image = UIImage()
            self.flickrItemArray[indexPath.row].getPhoto {(data) -> () in
                cell.update(data)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= flickrItemArray.count - 1  {
            fetchImages()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if flickrItemArray[indexPath.row].haveSmallData() {
            performSegue(withIdentifier: "DetailNearblyPhotoSegue", sender: indexPath)
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3
        return CGSize(width: width - 1, height: width - 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1)
        
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "DetailNearblyPhotoSegue" {
            if let conroller = segue.destination as? DetailViewController {
                if let indexPath = sender as? IndexPath {
                    conroller.itemImage = flickrItemArray[indexPath.row]
                }
            }
        }
    }
}


extension NearbyPhotosCollectionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            curentLocation = manager.location
            fetchImages()
        } else {
            curentLocation = nil
        }
        
    }
}

//
//  NearbyPhotosViewController.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import UIKit
import FlickrKit
import CoreLocation

class NearbyPhotosViewController: FlickrCollectionViewController {
    
    private var locationManager = CLLocationManager()
    private var curentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        checkLocation()
    }
    
    func checkLocation() {
        guard let location = curentLocation else {return}
        query = .userLocation(location)
        fetchImages(query)
    }
    
}

extension NearbyPhotosViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            curentLocation = manager.location
            checkLocation()
        } else {
            curentLocation = nil
        }
    }
    
}

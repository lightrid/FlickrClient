//
//  QueryService.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import Foundation
import FlickrKit
import CoreLocation

enum QueryType {
    case searchText(String)
    case userLocation(CLLocation)
}

struct QueryService {
    
    static func getURLsOfItems(_ currentPage: Int, _ query: QueryType, completionHandler: @escaping (_ photoItems: [FlickrItemCollection?]?, _ error: NSError?) -> ()) {
        
        var photoItems = [FlickrItemCollection?]()
        let flickrSearchParameters = FKFlickrPhotosSearch()
        
        switch query {
        case .userLocation(let userLocation):
            flickrSearchParameters.lat = String(userLocation.coordinate.latitude)
            flickrSearchParameters.lon = String(userLocation.coordinate.longitude)
            flickrSearchParameters.radius = "1"
        case .searchText(let searchText):
            flickrSearchParameters.text = searchText
        }
        
        flickrSearchParameters.per_page = "99"
        flickrSearchParameters.page = String(currentPage)
        
        FlickrKit.shared().call(flickrSearchParameters) { (response, error) -> Void in
            DispatchQueue.main.async {
                guard let photos = response.flatMap({FlickrKit.shared().photoArray(fromResponse: $0)}), !photos.isEmpty else {
                    if let error = error as NSError? {
                        completionHandler(nil, error)
                    }
                    return
                }
    
                for photoDictionary in photos {
                    let smallPhoto = FlickrItem(photoURL: FlickrKit.shared().photoURL(for: .small320, fromPhotoDictionary: photoDictionary))
                    let largePhoto = FlickrItem(photoURL: FlickrKit.shared().photoURL(for: .large1024, fromPhotoDictionary: photoDictionary))
                    let photoCollection = FlickrItemCollection(smallPhoto: smallPhoto, largePhoto: largePhoto)
                    photoItems.append(photoCollection)
                }
                completionHandler(photoItems, nil)
            }
        }
    }
    
}

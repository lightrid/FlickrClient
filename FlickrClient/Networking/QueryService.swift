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
        flickrSearchParameters.per_page = "99"
 
        switch query {
        case .userLocation(let userLocation):
            flickrSearchParameters.lat = String(userLocation.coordinate.latitude)
            flickrSearchParameters.lon = String(userLocation.coordinate.longitude)
            flickrSearchParameters.radius = "1"
        case .searchText(let searchText):
            flickrSearchParameters.text = searchText
        }
        
        flickrSearchParameters.page = String(currentPage)
        print(flickrSearchParameters.page!)
        FlickrKit.shared().call(flickrSearchParameters) { (response, error) -> Void in
            DispatchQueue.main.async {
                if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                    if !photoArray.isEmpty {
                        for photoDictionary in photoArray {
                            let smallPhoto = FlickrItem(photoURL: FlickrKit.shared().photoURL(for: .small320, fromPhotoDictionary: photoDictionary))
                            let largePhoto = FlickrItem(photoURL: FlickrKit.shared().photoURL(for: .large1024, fromPhotoDictionary: photoDictionary))
                            let photoCollection = FlickrItemCollection(smallPhoto: smallPhoto, largePhoto: largePhoto)
                            photoItems.append(photoCollection)
                        }
                        completionHandler(photoItems, nil)
                    } else {
                        completionHandler(nil, nil)
                    }
                } else {
                    if let error = error as NSError? {
                        
                        switch error.code {
                        case FKFlickrInterestingnessGetListError.serviceCurrentlyUnavailable.rawValue:
                            break;
                        default:
                            break;
                        }
                        completionHandler(nil,error)
                    }
                }
            }
        }
    }
}

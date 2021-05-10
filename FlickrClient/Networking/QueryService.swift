//
//  QueryService.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import Foundation
import FlickrKit


struct QueryService {
    
    static func getNearbyURLs(_ currentItemCount: Int, completionHandler: @escaping (_ photoItems: [FlickrItem?]?, _ error: NSError?) -> ()) {
        
        var photoItems = [FlickrItem?]()
        let flickrSearchParameters = FKFlickrPhotosSearch()
        
        flickrSearchParameters.lat = "49.839684" // потрібно отримати локацію
        flickrSearchParameters.lon = "24.029716"
        flickrSearchParameters.radius = "1"
        
        flickrSearchParameters.per_page = "100" //String(currentItemCount + 30)
        flickrSearchParameters.page = String(currentItemCount/100 + 1)
        print("NEW PAGE ON URLS:            \(flickrSearchParameters.page!)")
        FlickrKit.shared().call(flickrSearchParameters) { (response, error) -> Void in
            
            DispatchQueue.main.async {
                if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                    
                    for photoDictionary in photoArray {
                        let photoURL = FlickrKit.shared().photoURL(for: .small320, fromPhotoDictionary: photoDictionary)
                        let largePhotoURL = FlickrKit.shared().photoURL(for: .large1024, fromPhotoDictionary: photoDictionary)
                        let photo = FlickrItem(photoURL: photoURL, fullViewPhotoURL: largePhotoURL)
                        photoItems.append(photo)
                    }
                    completionHandler(photoItems, nil)
                    
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
    static func getSearchURLs(_ currentItemCount: Int, completionHandler: @escaping (_ photoURLs: [URL?]?, _ error: NSError?) -> Void) {
        
        var photoURLs = [URL?]()
        let flickrSearchParameters = FKFlickrPhotosSearch()
        //flickrInteresting.per_page = String(currentItemCount + 30)
        flickrSearchParameters.page = "1"
        flickrSearchParameters.text = "Lviv" // потрібно отримати текстовий запит
        FlickrKit.shared().call(flickrSearchParameters) { (response, error) -> Void in
            
            DispatchQueue.main.async {
                if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                    
                    for photoDictionary in photoArray {
                        let photoURL = FlickrKit.shared().photoURL(for: .small320, fromPhotoDictionary: photoDictionary)
                        photoURLs.append(photoURL)
                    }
                    completionHandler(photoURLs, nil)
                    
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

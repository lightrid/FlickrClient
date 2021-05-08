//
//  QueryService.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import Foundation
import FlickrKit


class QueryService {
    
    
    
    //    let defaultSession = URLSession(configuration: .default)
    //
    //    var dataTask: URLSessionDataTask?
    //    var errorMessage = ""
    //    var photos: [Photo] = []
    //
    //    typealias JSONDictionary = [String: Any]
    //    typealias QueryResult = ([Photo]?, String) -> Void
    //
    
    class func getNearbyURLs(_ currentItemCount: Int, completionHandler: @escaping (_ photoURLs: [URL?]?, _ error: NSError?) -> ()) {
        
        var photoURLs = [URL?]()
        let flickrSearchParameters = FKFlickrPhotosSearch()
        
        flickrSearchParameters.lat = "49.839684" // потрібно отримати локацію
        flickrSearchParameters.lon = "24.029716"
        flickrSearchParameters.radius = "1"
        flickrSearchParameters.per_page = "30" //String(currentItemCount + 30)
        flickrSearchParameters.page = String(currentItemCount/30 + 1)
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
    class func getSearchURLs(_ currentItemCount: Int, completionHandler: @escaping (_ photoURLs: [URL?]?, _ error: NSError?) -> Void) {
        
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

//
//  QueryService.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import Foundation
import FlickrKit


struct QueryService {
    
    
    static func getFullPhoto(_ url: URL?, completionHandler: @escaping (_ photoURL: URL?, _ error: NSError?) -> ()) {
        guard let url = url else { return }
        
        let flickrSearchParameters = FKFlickrPhotosSearch()
        completionHandler(url, nil)
        
    }
    
    static func getPhotoDictionary(_ currentItemCount: Int, completionHandler: @escaping (_ photoDictionary: [[String: Any]?]?, _ error: NSError?) -> ()) {
        
        var photoDictionaryArray = [[String: Any]?]()
        let flickrSearchParameters = FKFlickrPhotosSearch()
        
        flickrSearchParameters.lat = "49.839684" // потрібно отримати локацію
        flickrSearchParameters.lon = "24.029716"
        flickrSearchParameters.radius = "1"
        
        flickrSearchParameters.per_page = "100" //String(currentItemCount + 30)
        flickrSearchParameters.page = String(currentItemCount/100 + 1)
        
        FlickrKit.shared().call(flickrSearchParameters) { (response, error) -> Void in
            
            DispatchQueue.main.async {
                if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                    
                    for item in photoArray {
                        photoDictionaryArray.append(item)
                    }
                    completionHandler(photoDictionaryArray, nil)
                    
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
    
    static func getURLfromDictionary(_ photoDictionary: [[String: Any]?]?, completionHandler: @escaping (_ photoURLs: [URL?]?, _ error: NSError?) -> ()) {
        
    }
    
    static func getURL(_ photoDictionary: [[String: Any]]) -> [URL?]? {
        var photoURSs = [URL?]()
        for item in photoDictionary {
            let photoURL = FlickrKit.shared().photoURL(for: .large1024, fromPhotoDictionary: item)
            photoURSs.append(photoURL)
        }
        return photoURSs
    }
    
    static func getNearbyURLs(_ currentItemCount: Int, completionHandler: @escaping (_ photoURLs: [URL?]?, _ error: NSError?) -> ()) {
        
        var photoURLs = [URL?]()
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
                        
                        let photoURL = FlickrKit.shared().photoURL(for: .large1024, fromPhotoDictionary: photoDictionary)
                            
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

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
    //- TODO: Перевірка кількості URL (При ексклюзивному запиті перезаписує комірки)
    static func getURLsOfItems(_ currentItemCount: Int, _ query: QueryType, completionHandler: @escaping (_ photoItems: [FlickrItem?]?, _ error: NSError?) -> ()) {
        
        var photoItems = [FlickrItem?]()
        
        let flickrSearchParameters = FKFlickrPhotosSearch()
        flickrSearchParameters.per_page = "100"
        let currentPage = currentItemCount/100 + 1 // Загрузка URL відбувається в кількості 100 за один запит, для розуміння на якому ми етапі використовуємо дану змінну при пролистуванні комірок
       
       
        switch query {
        
        case .userLocation(let userLocation):
            flickrSearchParameters.lat = String(userLocation.coordinate.latitude)
            flickrSearchParameters.lon = String(userLocation.coordinate.longitude)
            flickrSearchParameters.radius = "1"
        case .searchText(let searchText):
            flickrSearchParameters.text = searchText
        }
        
        flickrSearchParameters.page = String(currentPage)

        print("NEW PAGE ON URLS:            \(flickrSearchParameters.page!)")
        
        FlickrKit.shared().call(flickrSearchParameters) { (response, error) -> Void in
            DispatchQueue.main.async {
                if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                    if photoArray.count > currentItemCount/currentPage {
                        print(photoArray.count)
                        for photoDictionary in photoArray {
                            let photoURL = FlickrKit.shared().photoURL(for: .small320, fromPhotoDictionary: photoDictionary)
                            print(photoURL)
                            let largePhotoURL = FlickrKit.shared().photoURL(for: .large1024, fromPhotoDictionary: photoDictionary)
                            let photo = FlickrItem(photoURL: photoURL, fullViewPhotoURL: largePhotoURL)
                            photoItems.append(photo)
                        }
                        completionHandler(photoItems, nil)
                    } else {
                        print("End of array: \(photoArray.count)")
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
//    static func getURLsOfItems(_ currentItemCount: Int, _ searchText: String?, _ userLocation:  CLLocation?, completionHandler: @escaping (_ photoItems: [FlickrItem?]?, _ error: NSError?) -> ()) {
//
//        var photoItems = [FlickrItem?]()
//
//        let flickrSearchParameters = FKFlickrPhotosSearch()
//        let currentPage = currentItemCount/100 + 1 // Загрузка URL відбувається в кількості 100 за один запит, для розуміння на якому ми етапі використовуємо дану змінну при пролистуванні комірок
//
//        if let location = userLocation {
//            flickrSearchParameters.lat = String(location.coordinate.latitude)
//            flickrSearchParameters.lon = String(location.coordinate.longitude)
//            flickrSearchParameters.radius = "1"
//            // Якщо ми можемо отримати розташування користувача, тоді розгортаємо опціонал і встановлюємо радіус пошуку від точки
//        } else {
//            flickrSearchParameters.text = searchText
//            // Якщо дістати локацію не вийшо, тоді здійснюємо пошук по текстомову запиту. Розгортати не потрібно, так як тип опціональний. В першій перевірці розгортали, адже потрібно додатково встановити радіус пошуку.
//        }
//
//        flickrSearchParameters.page = String(currentPage)
//
//        print("NEW PAGE ON URLS:            \(flickrSearchParameters.page!) \(String(describing: searchText))")
//        FlickrKit.shared().call(flickrSearchParameters) { (response, error) -> Void in
//            DispatchQueue.main.async {
//                if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
//                    if photoArray.count > currentItemCount/currentPage {
//                        print(photoArray.count)
//                        for photoDictionary in photoArray {
//                            let photoURL = FlickrKit.shared().photoURL(for: .small320, fromPhotoDictionary: photoDictionary)
//                            print(photoURL)
//                            let largePhotoURL = FlickrKit.shared().photoURL(for: .large1024, fromPhotoDictionary: photoDictionary)
//                            let photo = FlickrItem(photoURL: photoURL, fullViewPhotoURL: largePhotoURL)
//                            photoItems.append(photo)
//                        }
//                        completionHandler(photoItems, nil)
//                    } else {
//                        completionHandler(nil, nil)
//                    }
//                } else {
//                    if let error = error as NSError? {
//
//                        switch error.code {
//                        case FKFlickrInterestingnessGetListError.serviceCurrentlyUnavailable.rawValue:
//                            break;
//                        default:
//                            break;
//                        }
//                        completionHandler(nil,error)
//                    }
//                }
//            }
//        }
//    }
    
    
    
    //    static func getSearchURLs(_ currentItemCount: Int, completionHandler: @escaping (_ photoURLs: [URL?]?, _ error: NSError?) -> Void) {
    //
    //        var photoURLs = [URL?]()
    //        let flickrSearchParameters = FKFlickrPhotosSearch()
    //        //flickrInteresting.per_page = String(currentItemCount + 30)
    //        flickrSearchParameters.page = "1"
    //        flickrSearchParameters.text = "Lviv" // потрібно отримати текстовий запит
    //        FlickrKit.shared().call(flickrSearchParameters) { (response, error) -> Void in
    //
    //            DispatchQueue.main.async {
    //                if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
    //
    //                    for photoDictionary in photoArray {
    //                        let photoURL = FlickrKit.shared().photoURL(for: .small320, fromPhotoDictionary: photoDictionary)
    //                        photoURLs.append(photoURL)
    //                    }
    //                    completionHandler(photoURLs, nil)
    //
    //                } else {
    //                    if let error = error as NSError? {
    //
    //                        switch error.code {
    //                        case FKFlickrInterestingnessGetListError.serviceCurrentlyUnavailable.rawValue:
    //                            break;
    //                        default:
    //                            break;
    //                        }
    //                        completionHandler(nil,error)
    //                    }
    //                }
    //            }
    //        }
    //    }
}

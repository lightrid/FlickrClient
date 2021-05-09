//
//
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 09.05.2021.
//

import Foundation

class FlickrItem {
    var URL: URL
    private var photoData: Data?
    private var fullViewPhotoData: Data?
    
    init(url: URL) {
        URL = url
    }
    
    public func getPhoto(_ completion: @escaping(_ data: Data?) -> ()) {
        // Якщо маємо значення то повертаємо його одразу і перериваємо
        if let data = photoData {
            completion(data)
            print("HAVE")
            return
        }
        
        //Повідомляємо що даних немає
        completion(nil)
        //Завантажуємо дані
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: self.URL) {
                DispatchQueue.main.async {
                    self.photoData = data
                    print("NEW")
                    completion(data)
                }
            }
        }
    }
    public func getFullViewPhoto(_ completion: @escaping(_ data: Data?) -> ()) {
        // Якщо маємо значення то повертаємо його одразу і перериваємо
        if let data = fullViewPhotoData {
            completion(data)
            print("HAVE")
            return
        }
        
        //Повідомляємо що даних немає
        completion(nil)
        //Завантажуємо дані
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: self.URL) {
                DispatchQueue.main.async {
                    self.fullViewPhotoData = data
                    print("NEW")
                    completion(data)
                }
            }
        }
    }
    
    public func haveData() -> Bool {
        if photoData == nil {
            return false
        }
        return true
    }
}

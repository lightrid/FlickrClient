//
//
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 09.05.2021.
//

import Foundation

class FlickrItem {
    
    // TODO - Об'єднати GetPhoto i GetFullViewPhoto
    private var photoURL: URL
    private var photoData: Data?
    
    private var fullViewPhotoURL: URL
    private var fullViewPhotoData: Data?
    
    init(photoURL: URL, fullViewPhotoURL: URL) {
        self.photoURL = photoURL
        self.fullViewPhotoURL = fullViewPhotoURL
    }
    // TODO - Інколи URL є биті, потрібно ігнорувати їх. Скоріш за все потрібо cath блок до 36 рядка і видалити об'єкт з масиву.
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
            if let data = try? Data(contentsOf: self.photoURL) {
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
            if let data = try? Data(contentsOf: self.fullViewPhotoURL) {
                DispatchQueue.main.async {
                    self.fullViewPhotoData = data
                    print("NEW")
                    completion(data)
                }
            }
        }
    }
    
    public func haveSmallData() -> Bool {
        if photoData == nil {
            return false
        }
        return true
    }
}

//
//
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 09.05.2021.
//

import Foundation

class FlickrItem {
    
    private var photoURL: URL
    private var photoData: Data?
    
    init(photoURL: URL) {
        self.photoURL = photoURL
    }
    
    public func haveSmallData() -> Bool {
        if photoData == nil {
            return false
        }
        return true
    }
    // TODO - Інколи URL є биті, потрібно ігнорувати їх. Скоріш за все потрібо cath блок до 36 рядка і видалити об'єкт з масиву.
    public func getPhoto(_ completion: @escaping(_ data: Data?) -> ()) { //
        // Якщо маємо значення то повертаємо його одразу і перериваємо
        if let data = photoData {
            completion(data)
            return
        }
        //Повідомляємо що даних немає
        completion(nil)
        //Завантажуємо дані
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: self.photoURL) {
                DispatchQueue.main.async {
                    self.photoData = data
                    completion(data)
                }
            }
        }
    }
//    Засунути в флікр айтем колектіон
}

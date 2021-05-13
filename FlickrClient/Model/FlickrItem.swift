//
//
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 09.05.2021.
//

import Foundation

struct FlickrItemCollection {
    var smallPhoto: FlickrItem
    var largePhoto: FlickrItem
}

class FlickrItem {
    private var photoURL: URL
    private var photoData: Data?
    
    init(photoURL: URL) {
        self.photoURL = photoURL
    }
    
    public func haveData() -> Bool {
        return photoData != nil
    }
   
    public func getPhoto(_ completion: ((_ data: Data?) -> Void)?) { //
        guard let completion = completion else  {
            return
        }
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
}


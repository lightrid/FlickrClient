//
//  Photo.swift
//  FlickrClient
//
//  Created by Mykhailo Kviatkovskyi on 05.05.2021.
//

import Foundation
import UIKit

class Photo {
    let index: Int
    let name: String
    let previewURL: URL
    
    var downloaded = false
    
    init(index: Int, name: String, previewURL: URL) {
        self.index = index
        self.name = name
        self.previewURL = previewURL
    }
}

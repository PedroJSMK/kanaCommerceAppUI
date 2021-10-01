//
//  Item.swift
//  kanaCommerceAppUI
//
//  Created by PedroJSMK on 01/10/21.
//

import Foundation

struct Item: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case price
        case category
        case description
        case imageStringURL = "image"
    }
    
    enum Category: String, Codable {
        case electronics
        case jewelery
        case menClothing = "men`s clothing"
        case womenClothing = "women`s clothing"
    }
    
    let id: Int
    let name: String
    let price: Double
    let category: Category
    let description: String
    let imageStringURL: String
    
    init(
        id: Int,
        name: String,
        price: Double,
        category: Category,
        description: String,
        imageStringURL: String
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.description = description
        self.imageStringURL = imageStringURL
        
    }
}

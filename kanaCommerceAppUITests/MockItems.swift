//
//  MockItems.swift
//  kanaCommerceAppUITests
//
//  Created by PedroJSMK on 01/10/21.
//

import Foundation
@testable import kanaCommerceAppUI

struct MockItems {
     private static let JSONStringForItem = """
                                {
                                    \"id\": 1,
                                    \"title\": \"Fjallraven - Foldsack No. 1 Backpack, Fits 15 LapTops\",
                                    \"price\": 109,95,
                                    \"category\": \"men`s clothing\",
                                    \"description\": \"Description Description Description Description Description Description\",
                                    \"image\": \"https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_jpg"
                                }
                             """
    static let parsedItem = Item(
           id: 1,
           name: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 LapTops",
        price: 109.95,
           category: .menClothing,
           description: "Description Description Description Description Description Description",
           imageStringURL: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_jpg"
       )
        
    static var validItemData: Data {
        JSONStringForItem.data(using: .utf8)!
    }
    static var validArrayOftemsData: Data {
        "[\(JSONStringForItem)]".data(using: .utf8)!
    }
}

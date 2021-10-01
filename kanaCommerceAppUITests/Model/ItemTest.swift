//
//  ItemTest.swift
//  kanaCommerceAppUITests
//
//  Created by PedroJSMK on 01/10/21.
//

import XCTest
@testable import kanaCommerceAppUI

class ItemTest: XCTestCase {
    
    let sut = Item (
        id: 1,
        name: "Product",
        price: 12.99,
        category: .menClothing,
        description: "Description",
        imageStringURL: "http://image.com"
    )
    
    func testItem_init_ShouldRetainProperties() {
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.name, "Product")
        XCTAssertEqual(sut.price, 12.99)
        XCTAssertEqual(sut.category, .menClothing)
        XCTAssertEqual(sut.description, "Description")
        XCTAssertEqual(sut.imageStringURL, "http://image.com")
    }
    
    func testItem_codable_ShouldEncodeAndDecodeItem() throws {
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let decodedValue = try decoder.decode(Item.self, from: data)
        
        XCTAssertEqual(sut, decodedValue)
    }
    
    func testItem_decodeJSONString_ShouldDecodeToItem() throws {
        
        let expectedItem = MockItems.parsedItem
        let decoder = JSONDecoder()
        
 
        let decodedValue = try decoder.decode(Item.self, from: MockItems.validItemData)
        
        XCTAssertEqual(expectedItem, decodedValue)
    }
    
    func testItem_decodeWrongJSONString_ShouldFail() throws {
        
        let decoder = JSONDecoder()
        let wrongJSONString = """
                                {
                                    \"id\": 1,
                                    \"title\": \"Product\",
                                    \"price\": 12.99,
                                    \"category\": \"clothing\",
                                    \"description\": \"Description\",
                                    \"image\": \"http://image.com\"
                                }
                             """
        let data = wrongJSONString.data(using: .utf8)!
        
        XCTAssertThrowsError(try decoder.decode(Item.self, from: data))
    }
}


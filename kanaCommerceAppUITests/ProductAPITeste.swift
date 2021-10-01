//
//  ProductAPITeste.swift
//  kanaCommerceAppUITests
//
//  Created by Pedro Kanagusto on 01/10/21.
//

import XCTest
import Combine
@testable import kanaCommerceAppUI

protocol Requestable {
    var session: URLSession { get }
    func make<T: Decodable>(request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<T, Error>
}

class ApiClient: Requestable  {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func make<T: Decodable>(request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: request)
            .map(\.data).decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }

    
}

class ProductAPI {
    
    private let url = URL(string: "https://fakestoreapi.com/products")!
    
    lazy var request =  URLRequest(url: url)
     
    let client: Requestable
    
    init(client: Requestable = ApiClient()){
        self.client = client
    }
    
    func load() -> AnyPublisher<[Item], Error> {
        client.make(request: request, decoder: JSONDecoder())
    }
}



class ProductAPITeste: XCTestCase {

    func testProductAPI_init_ShouldRetainProperties() {
   
        let sut = ProductAPI()
    
        XCTAssertNotNil(sut.client)
        XCTAssertEqual(sut.request.url?.absoluteString, "https://fakestoreapi.com/products")
    }
    
    func testProductAPI_Load_ShouldReturnAnArrayOfProducts() {

        let sut = ProductAPI()
        let expectation = expectation(description: "Should receive an Array of Items")
       
        let cancellable = sut.load().sink { completion in
            switch completion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    break
            }
            expectation.fulfill()
        } receiveValue: { items in
            XCTAssertEqual(items.first?.name, "Fjallraven - Foldsack No. 1 Backpack, Fits 15 LapTops")
        }
            
       waitForExpectations(timeout: 5)
        cancellable.cancel()
    }
}

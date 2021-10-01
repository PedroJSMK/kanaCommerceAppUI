//
//  ProductAPITeste.swift
//  kanaCommerceAppUITests
//
//  Created by PedroJSMK on 01/10/21.
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

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?
    
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
       guard let (response, data, error) = Self.requestHandler?(request) else {
            XCTFail("RequestHandler Should't be nil")
        return
        }
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
        
    }
    
    override func stopLoading() {
       //
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
    
    lazy var client: Requestable = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return ApiClient(session: session)
    }()

    func testProductAPI_init_ShouldRetainProperties() {
   
        let sut = ProductAPI()
    
        XCTAssertNotNil(sut.client)
        XCTAssertEqual(sut.request.url?.absoluteString, "https://fakestoreapi.com/products")
    }
    
    func testProductAPI_Load_ShouldReturnAnArrayOfProducts() {

        let sut = ProductAPI(client: client)
        let expectation = expectation(description: "Should receive an Array of Items")
       
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), MockItems.validArrayOftemsData, nil)
        }
        
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
            
       waitForExpectations(timeout: 1)
        cancellable.cancel()
    }
}

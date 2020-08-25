//
//  ApiAdapter.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//
import Foundation
import Alamofire

class ApiAdapter {
    
    static let get = ApiAdapter()
    
    private let alamofireManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let sessionManager = Alamofire.Session(configuration: configuration)
        return sessionManager
    }()
    
    private init() {
        
    }
    
    func requestPokeDesk<T: Decodable>(url: String, method: Alamofire.HTTPMethod = .get,
                                        queryParams: [String: String] = [:], body: Parameters? = nil,
                                        headers: HTTPHeaders? = nil, completionHandler: @escaping (AFDataResponse<T>) -> Void) {
        var urlComponent = URLComponents(string: url)!
        if queryParams.count > 0 {
            let queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponent.queryItems = queryItems
        }
        
        alamofireManager.request(urlComponent, method: method, parameters: body, encoding: JSONEncoding.prettyPrinted, headers: headers).responseDecodable(completionHandler: completionHandler)
    }
    
}

//
//  SessionProvider.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/18/21.
//

import Foundation
import UIKit


struct SessionProvider {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func requestImageData(urlString: String, completion: @escaping (Result<Data, NetworkError>)->()) {
        let networkOperation = NetworkOperation(session: session)
        guard let url = URL(string: urlString)
        else {
            print("Error || Invalid URL string")
            return
        }
        networkOperation.url = url
        networkOperation.completion = { (data, res, err) in
            if let err = err {
                completion(.failure(.sessionError(err)))
                return
            }
            guard let response = res as? HTTPURLResponse
            else {
                print("Error || Unexpected response found")
                completion(.failure(.unknownError))
                return
            }
            
            switch response.statusCode {
            case 200...299:
                guard let data = data
                else {
                    completion(.failure(.unknownError))
                    return
                }
                completion(.success(data))
            default:
                print("Error || Response Status Code: \(response.statusCode)", "Description: \(response.description)")
                completion(.failure(.responseError))
            }
        }
        NetworkOperationQueue.shared.addOperation(networkOperation)
    }
    
    func request<T: Decodable>(_ type: T.Type, service: ServiceProtocol, completion: @escaping (Result<T, NetworkError>)->()) {
        let operation: AsyncOperation
        // Since no request other than get for now, request is limited to 'get' for now
        switch service.method {
        case .get:
            operation = get(from: service.getURL()!, completion: completion)
        /// add more methods here ...
        }
        
        NetworkOperationQueue.shared.addOperation(operation)
    }
    
    private func get<T: Decodable>(from url: URL, completion: @escaping (Result<T, NetworkError>)->()) -> AsyncOperation {
        let getOperation = NetworkOperation(session: session)
        getOperation.url = url
        getOperation.completion = { (data, res, err) in
            if let err = err {
                completion(.failure(.sessionError(err)))
                return
            }
            guard let response = res as? HTTPURLResponse
            else {
                print("Error || Unexpected response found")
                completion(.failure(.unknownError))
                return
            }

            switch response.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    guard let data = data else { return }
                    let model = try decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch (let err) {
                    print("Error || Failed to parse, \(err.localizedDescription)")
                    return completion(.failure(.parseError))
                }

            default:
                print("Error || Response Status Code: \(response.statusCode)", "Description: \(response.description)")
                completion(.failure(.responseError))
            }
        }
        return getOperation
    }
}

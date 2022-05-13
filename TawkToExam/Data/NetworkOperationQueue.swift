//
//  NetworkOperationQueue.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/20/21.
//

import Foundation

class NetworkOperationQueue {
    static let shared = {
        NetworkOperationQueue()
    }()
    
    private let queue: OperationQueue
    
    private init() {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
    }
    
    func addOperation(completion: @escaping (()->())) {
        let operation = Operation()
        operation.completionBlock = {
            completion()
        }
        
        queue.addOperation(operation)
    }
    
    func addOperation(_ operation: AsyncOperation) {
        DispatchQueue.background(background: { [weak self] in
            self?.queue.addOperations([operation], waitUntilFinished: true)
        })
    }
}

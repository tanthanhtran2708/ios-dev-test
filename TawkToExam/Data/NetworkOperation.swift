//
//  NetworkOperation.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/21/21.
//

import Foundation

final class NetworkOperation: AsyncOperation {
    var url: URL? = nil
    var completion: ((Data?, URLResponse?, Error?)->())? = nil
    private let session: URLSession
    private var dataTask: URLSessionTask? = nil
    
    init(session: URLSession) {
        self.session = session
    }

    override func main() {
        attemptRequest()
    }
    
    private func attemptRequest() {
        guard let url = url,
              let completion = completion
        else {
            print("Error || Required variables not set. (url, completion)")
            return
        }
        
        dataTask = session.dataTask(with: url) { (data, res, err) in
            if !ReachabilityObserver.shared.isConnectedToNetwork() {
                print("Log || Operation suspended")
                NotificationCenter.default.addObserver(self, selector: #selector(self.handleChangeInNetworkConnection), name: .networkConnectionChanged, object: nil)
            } else {
                completion(data, res, err)
                self.finish()
            }
            
        }
        
        dataTask?.resume()
    }
    
    @objc func handleChangeInNetworkConnection() {
        print("Log || Operation resumed")
        self.attemptRequest()
        NotificationCenter.default.removeObserver(self)
    }

    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}

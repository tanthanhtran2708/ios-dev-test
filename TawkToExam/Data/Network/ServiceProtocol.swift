//
//  ServiceProtocol.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/20/21.
//

import Foundation

protocol ServiceProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

extension ServiceProtocol {
    func getURL() -> URL? {
        return URL(string: baseURL + path)
    }
}

enum HTTPMethod {
    case get
}

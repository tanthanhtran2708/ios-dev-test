//
//  NetworkError.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/20/21.
//

enum NetworkError: Error {
    case responseError, parseError, unknownError, sessionError(Error)
}

//
//  NetworkError.swift
//  NatifeTestTask
//
//  Created by Евгений  on 08/09/2022.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURL = "invalid URL"
    case invalidResponse = "Invalid response"
    case invalidStatusCode = "Invalid status code"
    case noData = "No data occure"
    case invalidData = "Invalid Data"
}

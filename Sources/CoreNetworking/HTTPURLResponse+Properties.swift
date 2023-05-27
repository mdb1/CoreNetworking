//
//  HTTPURLResponse+Properties.swift
//  
//
//  Created by Manu on 27/05/2023.
//

import Foundation

extension HTTPURLResponse {
    var logProperties: [String: Any] {
        var logProperties: [String: Any] = [:]
        logProperties["Status Code"] = statusCode.description
        logProperties["URL"] = url?.absoluteString
        return logProperties
    }
}

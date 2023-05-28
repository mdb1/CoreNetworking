//
//  Request+Properties.swift
//  
//
//  Created by Manu on 28/05/2023.
//

import Foundation

extension Request {
    var logProperties: [String: Any] {
        var logProperties: [String: Any] = [:]
        logProperties["Request's Internal Id"] = internalId
        if let url = urlRequest.url {
            logProperties["URL"] = url.absoluteString
        }
        logProperties["HTTP Method"] = urlRequest.httpMethod
        if let headers = urlRequest.allHTTPHeaderFields, headers.count > 0 {
            logProperties["HTTP Headers"] = headers
        }
        if let body = urlRequest.httpBody {
            logProperties["HTTP Body"] = String(data: body, encoding: .utf8)
        }
        return logProperties
    }
}

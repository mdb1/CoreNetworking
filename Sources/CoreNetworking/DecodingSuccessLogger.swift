//
//  DecodingSuccessLogger.swift
//  
//
//  Created by Manu on 24/05/2023.
//

import Foundation

/// Logs information to the console when decoding network models.
struct DecodingSuccessLogger {
    func logInfo(model: Decodable, data: Data) {
        var logProperties: [String: String] = [:]
        logProperties["UTF8 - String"] = String(data: data, encoding: .utf8)

        print("✅ ===> JSON Decoding start:")
        print("Model:")
        dump(model)
        print("Additional Info:")
        dump(logProperties)
        print("✅ <=== JSON Decoding end.")
        print("")
    }
}

//
//  Data+PrettyPrinted.swift
//  
//
//  Created by Manu on 28/05/2023.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: NSString {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              var prettyPrintedString = String(data: data, encoding: .utf8) else {
            return ""
        }

        prettyPrintedString = prettyPrintedString.replacingOccurrences(of: "\\/", with: "/")
        return prettyPrintedString as NSString
    }
}

extension Dictionary where Key == String, Value == Any {
    func toJSONData() -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            return jsonData
        } catch {
            Current.logger.error("Error converting dictionary to JSON data: \(error.localizedDescription)")
            return nil
        }
    }
}

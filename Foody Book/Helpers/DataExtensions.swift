//
//  DataExtensions.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import Foundation

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(
                data: self,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
        } catch {
            print("error:", error)
            return  nil
        }
    }
    
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

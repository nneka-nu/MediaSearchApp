//
//  String+StripHTML.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/4/22.
//

import Foundation

extension String {
    func stripHTML() -> String {
        var text = self.replacingOccurrences(of: "<br />", with: "\n")
        text = text.replacingOccurrences(of: "&#xa0;", with: " ")
        text = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return text
    }
}

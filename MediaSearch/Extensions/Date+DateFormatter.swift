//
//  Date+DateFormatter.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/6/22.
//

import Foundation

extension Date {
    static let mediumDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    var mediumDateStyle: String {
        Self.mediumDateFormatter.string(from: self)
    }
}

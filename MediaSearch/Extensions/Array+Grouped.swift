//
//  Array+Grouped.swift
//  MediaSearch
//
//  Created by Nneka Udoh on 1/16/22.
//

import Foundation

extension Collection {
    // group values in a one-dimensional array by the specified number
    func grouped(by number: Int) -> [[Element]] {
        var array: [[Element]] = []

        for (index, item) in self.enumerated() {
            let groupIndex = index / number
            if array.count == groupIndex {
                array.append([item])
                continue
            }
            array[groupIndex].append(item)
        }

        return array
    }
}

//
//  File.swift
//
//
//

import Foundation

struct Elevation: Equatable {
    public var positive: Double
    public var negative: Double

    public init(positive: Double, negative: Double) {
        self.positive = positive
        self.negative = negative
    }

    static func == (lhs: Elevation, rhs: Elevation) -> Bool {
        lhs.positive == rhs.positive && lhs.negative == rhs.negative
    }

    static func += (lhs: inout Elevation, rhs: Elevation) {
        lhs.positive += rhs.positive
        lhs.negative += rhs.negative
    }
}

public struct Area: Equatable {
    public var minLongitude: Double
    public var minLatitude: Double
    public var maxLongitude: Double
    public var maxLatitude: Double

    public init(minLongitude: Double, minLatitude: Double, maxLongitude: Double, maxLatitude: Double) {
        self.minLatitude = minLatitude
        self.minLongitude = minLongitude
        self.maxLatitude = maxLatitude
        self.maxLongitude = maxLongitude
    }

    public static func == (lhs: Area, rhs: Area) -> Bool {
        lhs.minLatitude == rhs.minLatitude && lhs.maxLatitude == rhs.maxLatitude && lhs.minLongitude == rhs.minLongitude && lhs.maxLongitude == rhs.maxLongitude
    }
}

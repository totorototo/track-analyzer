//
//  File.swift
//
//
//  Created by Gilbert, Thomas on 05/10/2021.
//

import Foundation

public struct WayPoint: Equatable {
    public let longitude: Double
    public let latitude: Double
    public let altitude: Double

    public init(longitude: Double, latitude: Double, altitude: Double) {
        self.altitude = altitude
        self.latitude = latitude
        self.longitude = longitude
    }

    func calculateDistanceTo(to: WayPoint) -> Double {
        let R = 6371.0 // metres

        let origin_latitude = (latitude * Double.pi) / 180
        let destination_latitude = (to.latitude * Double.pi) / 180

        let delta_latitude = ((to.latitude - latitude) * Double.pi) / 180
        let delta_longitude = ((to.longitude - longitude) * Double.pi) / 180

        let central_angle_inner =
            sin(delta_latitude / 2) * sin(delta_latitude / 2) +
            cos(origin_latitude) *
            cos(destination_latitude) *
            sin(delta_longitude / 2) *
            sin(delta_longitude / 2)
        let central_angle = 2 * atan2(sqrt(central_angle_inner), sqrt(1 - central_angle_inner))

        return R * central_angle
    }

    func calculateBearingTo(to: WayPoint) -> Double {
        let origin_latitude = (latitude * Double.pi) / 180
        let destination_latitude = (to.latitude * Double.pi) / 180
        let origin_longitude = (longitude * Double.pi) / 180
        let destination_longitude = (to.longitude * Double.pi) / 180

        let delta_longitude = (to.longitude - longitude) * (Double.pi / 180)

        let y = sin(delta_longitude) * cos(destination_latitude)
        let x = cos(origin_latitude) * sin(destination_latitude)
            - sin(origin_latitude)
            * cos(destination_latitude)
            * cos(destination_longitude - origin_longitude)
        let teta = atan2(y, x)

        return ((teta * 180.0) / Double.pi + 360.0).truncatingRemainder(dividingBy: 360.0)
    }

    func calculateElevationTo(to: WayPoint) -> Elevation {
        let delta = to.altitude - altitude
        if delta > 0.0 {
            return Elevation(positive: delta, negative: 0.0)
        } else {
            return Elevation(positive: 0.0, negative: abs(delta))
        }
    }

    func isInArea(area: Area) -> Bool {
        longitude > area.minLongitude
            && longitude < area.maxLongitude
            && latitude > area.minLatitude
            && latitude < area.maxLatitude
    }

    func isInRadius(centerWayPoint: WayPoint, radius: Double) -> Bool {
        let distance = calculateDistanceTo(to: centerWayPoint)
        return distance - radius < 0
    }

    public static func == (lhs: WayPoint, rhs: WayPoint) -> Bool {
        lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude && lhs.altitude == rhs.altitude
    }
}

//
//  PointModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation
import CoreLocation

struct Point: Identifiable {
    var id: String
    var province: String
    var name: String
    var title: String
    var activityId: String
    var activityType: String
    var image: String
    var coordinates: CLLocationCoordinate2D
    var abstract: String 
}

struct Coordinate: Identifiable {
    var id = UUID()
    var latitude: Double
    var longitude: Double
}

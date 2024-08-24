//
//  Spot.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/8/24.
//

import Foundation

struct Spot: Identifiable, Codable {
    var id: String
    var abstract: String
    var activityID: String
    var activityType: String
    var coordinates: Coordinates
    var image: String
    var isCompleted: Bool
    var name: String
    var province: String
    var title: String
}

struct Coordinates: Codable {
    var latitude: Double
    var longitude: Double
}

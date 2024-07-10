//
//  LocationActivity.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/7/24.
//

import Foundation
import SwiftUI


// Modelo de datos para la ubicación
struct Location: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var category: String
    var place: String
    var activity: Activity
}



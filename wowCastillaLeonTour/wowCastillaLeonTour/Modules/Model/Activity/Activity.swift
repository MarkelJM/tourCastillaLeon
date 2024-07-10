//
//  Activity.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/7/24.
//

import Foundation
import SwiftUI


// Modelo de datos para la actividad
struct Activity: Identifiable, Codable {
    var id: String = UUID().uuidString
    var type: ActivityType
    var question: String?
    var options: [String]?
    var correctAnswer: String?
    var additionalInfo: String?
    var puzzlePieces: [PuzzlePiece]?
    var imageUrl: String?
}


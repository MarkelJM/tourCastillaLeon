//
//  PuzzlePiece.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/7/24.
//

import Foundation
import SwiftUI



// Modelo de datos para piezas de puzzle
struct PuzzlePiece: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var description: String
    var imageUrl: String
    var correctPosition: Int
}

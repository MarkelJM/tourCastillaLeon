//
//  PuzzleModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//
import Foundation

struct Puzzle: Identifiable {
    var id: String
    var province: String
    var question: String
    var questionImage: String
    var images: [String: String]
    var correctPositions: [String: (x: Double, y: Double)]
    var customMessage: String
    var correctAnswerMessage: String
    var incorrectAnswerMessage: String
    var abstract: String 
}


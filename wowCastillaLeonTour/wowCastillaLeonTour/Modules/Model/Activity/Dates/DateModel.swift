//
//  DateModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation

struct DateEvent: Identifiable {
    var id: String { eventId }
    var eventId: String
    var province: String
    var question: String
    var options: [String]
    var correctAnswer: [String]
    var customMessage: String
    var correctAnswerMessage: String
    var incorrectAnswerMessage: String
}

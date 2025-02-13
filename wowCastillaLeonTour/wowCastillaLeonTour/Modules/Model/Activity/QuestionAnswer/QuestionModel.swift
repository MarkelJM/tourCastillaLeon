//
//  QuestionModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation

struct QuestionAnswer: Identifiable {
    var id: String
    var province: String
    var question: String
    var options: [String]
    var correctAnswer: String
    var customMessage: String
    var correctAnswerMessage: String
    var incorrectAnswerMessage: String
    var isCapital: Bool
    var challenge: String
    var informationDetail: String  
}

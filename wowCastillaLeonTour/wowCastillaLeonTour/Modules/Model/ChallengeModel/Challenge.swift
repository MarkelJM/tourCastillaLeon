//
//  Challenge.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/8/24.
//

import Foundation

struct Challenge: Identifiable, Codable {
    var id: String 
    var challengeName: String
    var challengeTaskIDs: [String]
    var challengeTitle: String
    var correctAnswerMessage: String
    var incorrectMessage: String
    var image: String
    var isBegan: Bool
    var province: String
    var taskAmount: Int
    var challengeMessage: String
}

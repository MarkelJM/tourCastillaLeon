//
//  CoinModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation

struct Coin: Identifiable {
    var id: String { coinId }
    var coinId: String
    var province: String
    var description: String
    var customMessage: String
    var correctAnswerMessage: String
    var incorrectAnswerMessage: String
    var prize: String
}

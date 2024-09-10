//
//  SpecialPrizeModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//

import Foundation

struct SpecialPrize: Identifiable {
    var id: String
    var cityTaskIDs: [String]?
    var correctAnswerMessage: String
    var image: String
    var province: String
    var tasksAmount: Int
}

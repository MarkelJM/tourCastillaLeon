//
//  TakePhotoModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation

struct TakePhoto: Identifiable {
    var id: String { takePhotoId }
    var takePhotoId: String
    var province: String
    var question: String
    var customMessage: String
    var correctAnswerMessage: String
    var incorrectAnswerMessage: String
}

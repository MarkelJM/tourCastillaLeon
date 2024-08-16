//
//  Coin+Firebase.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation
import FirebaseFirestore

extension Coin {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let province = firestoreData["province"] as? String,
              let description = firestoreData["description"] as? String,
              let customMessage = firestoreData["customMessage"] as? String,
              let correctAnswerMessage = firestoreData["correctAnswerMessage"] as? String,
              let incorrectAnswerMessage = firestoreData["incorrectAnswerMessage"] as? String,
              let prize = firestoreData["prize"] as? String,
              let isCapital = firestoreData["isCapital"] as? Bool else {
            return nil
        }

        self.id = id
        self.province = province
        self.description = description
        self.customMessage = customMessage
        self.correctAnswerMessage = correctAnswerMessage
        self.incorrectAnswerMessage = incorrectAnswerMessage
        self.prize = prize
        self.isCapital = isCapital
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "province": province,
            "description": description,
            "customMessage": customMessage,
            "correctAnswerMessage": correctAnswerMessage,
            "incorrectAnswerMessage": incorrectAnswerMessage,
            "prize": prize,
            "isCapital": isCapital
        ]
    }
}

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
              let custom_message = firestoreData["custom_message"] as? String,
              let correct_answer_message = firestoreData["correct_answer_message"] as? String,
              let incorrect_answer_message = firestoreData["incorrect_answer_message"] as? String,
              let prize = firestoreData["prize"] as? String,
              let isCapital = firestoreData["isCapital"] as? Bool else {
            return nil
        }

        self.id = id
        self.province = province
        self.description = description
        self.customMessage = custom_message
        self.correctAnswerMessage = correct_answer_message
        self.incorrectAnswerMessage = incorrect_answer_message
        self.prize = prize
        self.isCapital = isCapital
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "province": province,
            "description": description,
            "custom_message": customMessage,
            "correct_answer_message": correctAnswerMessage,
            "incorrect_answer_message": incorrectAnswerMessage,
            "prize": prize,
            "isCapital": isCapital
        ]
    }
}

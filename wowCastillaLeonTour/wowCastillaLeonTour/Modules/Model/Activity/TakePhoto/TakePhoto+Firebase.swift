//
//  TakePhoto+Firebase.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation
import FirebaseFirestore

extension TakePhoto {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let province = firestoreData["province"] as? String,
              let question = firestoreData["question"] as? String,
              let customMessage = firestoreData["customMessage"] as? String,
              let correctAnswerMessage = firestoreData["correctAnswerMessage"] as? String,
              let incorrectAnswerMessage = firestoreData["incorrectAnswerMessage"] as? String else {
            return nil
        }

        self.id = id
        self.province = province
        self.question = question
        self.customMessage = customMessage
        self.correctAnswerMessage = correctAnswerMessage
        self.incorrectAnswerMessage = incorrectAnswerMessage
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "province": province,
            "question": question,
            "customMessage": customMessage,
            "correctAnswerMessage": correctAnswerMessage,
            "incorrectAnswerMessage": incorrectAnswerMessage
        ]
    }
}

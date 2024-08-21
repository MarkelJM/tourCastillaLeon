//
//  FillGap+Firebase.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation
import FirebaseFirestore

extension FillGap {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let province = firestoreData["province"] as? String,
              let question = firestoreData["question"] as? String,
              let images = firestoreData["images"] as? String,
              let correctPositions = firestoreData["correct_positions"] as? [String], // Cambiado a "correct_positions"
              let customMessage = firestoreData["custom_message"] as? String, // Cambiado a "custom_message"
              let correctAnswerMessage = firestoreData["correct_answer_message"] as? String, // Cambiado a "correct_answer_message"
              let incorrectAnswerMessage = firestoreData["incorrect_answer_message"] as? String, // Cambiado a "incorrect_answer_message"
              let isCapital = firestoreData["isCapital"] as? Bool else { // "isCapital" ya estaba bien
            return nil
        }

        self.id = id
        self.province = province
        self.question = question
        self.images = images
        self.correctPositions = correctPositions
        self.customMessage = customMessage
        self.correctAnswerMessage = correctAnswerMessage
        self.incorrectAnswerMessage = incorrectAnswerMessage
        self.isCapital = isCapital
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "province": province,
            "question": question,
            "images": images,
            "correct_positions": correctPositions, // Cambiado a "correct_positions"
            "custom_message": customMessage, // Cambiado a "custom_message"
            "correct_answer_message": correctAnswerMessage, // Cambiado a "correct_answer_message"
            "incorrect_answer_message": incorrectAnswerMessage, // Cambiado a "incorrect_answer_message"
            "isCapital": isCapital
        ]
    }
}

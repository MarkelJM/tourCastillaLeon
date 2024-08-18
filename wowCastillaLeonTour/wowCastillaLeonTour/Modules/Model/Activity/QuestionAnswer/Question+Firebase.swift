//
//  Question+Firebase.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation
import FirebaseFirestore

extension QuestionAnswer {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let province = firestoreData["province"] as? String,
              let question = firestoreData["question"] as? String,
              let options = firestoreData["options"] as? [String],
              let correctAnswer = firestoreData["correct_answer"] as? String, // Cambiado a "correct_answer"
              let customMessage = firestoreData["custom_message"] as? String, // Cambiado a "custom_message"
              let correctAnswerMessage = firestoreData["correct_answer_message"] as? String, // Cambiado a "correct_answer_message"
              let incorrectAnswerMessage = firestoreData["incorrect_answer_message"] as? String, // Cambiado a "incorrect_answer_message"
              let isCapital = firestoreData["isCapital"] as? Bool else { // "isCapital" ya estaba bien
            print("Failed to decode one of the fields:")
            print("id: \(firestoreData["id"] ?? "nil")")
            print("province: \(firestoreData["province"] ?? "nil")")
            print("question: \(firestoreData["question"] ?? "nil")")
            print("options: \(firestoreData["options"] ?? "nil")")
            print("correctAnswer: \(firestoreData["correct_answer"] ?? "nil")")
            print("customMessage: \(firestoreData["custom_message"] ?? "nil")")
            print("correctAnswerMessage: \(firestoreData["correct_answer_message"] ?? "nil")")
            print("incorrectAnswerMessage: \(firestoreData["incorrect_answer_message"] ?? "nil")")
            print("isCapital: \(firestoreData["isCapital"] ?? "nil")")
            return nil
        }

        self.id = id
        self.province = province
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
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
            "options": options,
            "correct_answer": correctAnswer, // Cambiado a "correct_answer"
            "custom_message": customMessage, // Cambiado a "custom_message"
            "correct_answer_message": correctAnswerMessage, // Cambiado a "correct_answer_message"
            "incorrect_answer_message": incorrectAnswerMessage, // Cambiado a "incorrect_answer_message"
            "isCapital": isCapital
        ]
    }
}

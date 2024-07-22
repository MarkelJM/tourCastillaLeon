//
//  Puzzle+Firebase.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation
import FirebaseFirestore



extension Puzzle {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let province = firestoreData["province"] as? String,
              let question = firestoreData["question"] as? String,
              let questionImage = firestoreData["questionImage"] as? String,
              let images = firestoreData["images"] as? [String: String],
              let correctPositionsData = firestoreData["correctPositions"] as? [String: [String: NSNumber]],
              let customMessage = firestoreData["customMessage"] as? String,
              let correctAnswerMessage = firestoreData["correctAnswerMessage"] as? String,
              let incorrectAnswerMessage = firestoreData["incorrectAnswerMessage"] as? String,
              let abstract = firestoreData["abstract"] as? String else { // Añadido abstract
            return nil
        }

        let correctPositions = correctPositionsData.compactMapValues { data -> (x: Double, y: Double)? in
            guard let x = data["x"]?.doubleValue, let y = data["y"]?.doubleValue else { return nil }
            return (x: x, y: y)
        }

        self.id = id
        self.province = province
        self.question = question
        self.questionImage = questionImage
        self.images = images
        self.correctPositions = correctPositions
        self.customMessage = customMessage
        self.correctAnswerMessage = correctAnswerMessage
        self.incorrectAnswerMessage = incorrectAnswerMessage
        self.abstract = abstract // Asignado el valor a abstract
    }

    func toFirestoreData() -> [String: Any] {
        let correctPositionsData = correctPositions.mapValues { ["x": $0.x, "y": $0.y] }

        return [
            "id": id,
            "province": province,
            "question": question,
            "questionImage": questionImage,
            "images": images,
            "correctPositions": correctPositionsData,
            "customMessage": customMessage,
            "correctAnswerMessage": correctAnswerMessage,
            "incorrectAnswerMessage": incorrectAnswerMessage,
            "abstract": abstract // Añadido abstract en la conversión a Firestore data
        ]
    }
}

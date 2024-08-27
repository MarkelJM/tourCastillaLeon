//
//  Challenge+Firebase.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/8/24.
//

import FirebaseFirestore

extension Challenge {
    init?(from firestoreData: [String: Any]) {
        guard let challengeName = firestoreData["challengeName"] as? String,
              let challengeTaskIDs = firestoreData["challengeTaskIDs"] as? [String],
              let challengeTitle = firestoreData["challengeTitle"] as? String,
              let correctAnswerMessage = firestoreData["correct_answer_message"] as? String,
              let incorrectMessage = firestoreData["incorrect_message"] as? String,
              let image = firestoreData["image"] as? String,
              let isBegan = firestoreData["isBegan"] as? Bool,
              let province = firestoreData["province"] as? String,
              let taskAmount = firestoreData["taskamount"] as? Int,
              let challengeMessage = firestoreData["challenge_message"] as? String else { // Campo agregado
            return nil
        }

        self.id = firestoreData["challengeID"] as? String ?? "" // Asignamos el id si existe en Firestore, si no, vacío
        self.challengeName = challengeName
        self.challengeTaskIDs = challengeTaskIDs
        self.challengeTitle = challengeTitle
        self.correctAnswerMessage = correctAnswerMessage
        self.incorrectMessage = incorrectMessage
        self.image = image
        self.isBegan = isBegan
        self.province = province
        self.taskAmount = taskAmount
        self.challengeMessage = challengeMessage // Asignación del nuevo campo
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "challengeName": challengeName,
            "challengeTaskIDs": challengeTaskIDs,
            "challengeTitle": challengeTitle,
            "correct_answer_message": correctAnswerMessage,
            "incorrect_message": incorrectMessage,
            "image": image,
            "isBegan": isBegan,
            "province": province,
            "taskamount": taskAmount,
            "challenge_message": challengeMessage // Incluyendo el nuevo campo en la salida
        ]
    }
}

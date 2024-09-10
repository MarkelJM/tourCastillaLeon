//
//  SpecialPrize+Firebase.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//

import FirebaseFirestore

extension SpecialPrize {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let correctAnswerMessage = firestoreData["correct_answer_message"] as? String,
              let image = firestoreData["image"] as? String,
              let province = firestoreData["province"] as? String,
              let tasksAmount = firestoreData["tasksAmount"] as? Int else {
            return nil
        }

        self.id = id
        self.cityTaskIDs = firestoreData["cityTaskIDs"] as? [String]
        self.correctAnswerMessage = correctAnswerMessage
        self.image = image
        self.province = province
        self.tasksAmount = tasksAmount
    }

    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "cityTaskIDs": cityTaskIDs ?? [],
            "correct_answer_message": correctAnswerMessage,
            "image": image,
            "province": province,
            "tasksAmount": tasksAmount
        ]
    }
}

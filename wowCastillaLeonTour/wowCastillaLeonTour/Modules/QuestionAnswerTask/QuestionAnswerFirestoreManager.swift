//
//  QuestionAnswerFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Foundation
import Combine
import FirebaseFirestore

class QuestionAnswerFirestoreManager {
    private let db = Firestore.firestore()

    func fetchQuestionAnswerById(_ id: String) -> AnyPublisher<QuestionAnswer, Error> {
        Future { promise in
            self.db.collection("questionAnswers").document(id).getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = snapshot?.data(), let questionAnswer = QuestionAnswer(from: data) {
                    promise(.success(questionAnswer))
                } else {
                    promise(.failure(NSError(domain: "Document not found", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

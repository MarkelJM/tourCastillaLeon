//
//  QuestionAnswerDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Foundation
import Combine

class QuestionAnswerDataManager {
    private let firestoreManager = QuestionAnswerFirestoreManager()
    
    func fetchQuestionAnswerById(_ id: String) -> AnyPublisher<QuestionAnswer, Error> {
        return firestoreManager.fetchQuestionAnswerById(id)
    }
}

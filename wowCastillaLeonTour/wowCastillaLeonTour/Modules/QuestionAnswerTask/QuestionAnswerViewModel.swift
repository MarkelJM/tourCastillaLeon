//
//  QuestionAnswerViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI
import Combine

class QuestionAnswerViewModel: BaseViewModel {
    @Published var questionAnswer: QuestionAnswer?
    @Published var isLoading: Bool = true
    @Published var selectedOption: String?
    @Published var showResultModal: Bool = false
    
    private let dataManager = QuestionAnswerDataManager()
    private var activityId: String
    
    init(activityId: String) {
        self.activityId = activityId
        super.init()
        fetchUserProfile() // brings user data when the viewmodel is created
    }
    
    func fetchQuestionAnswer() {
        isLoading = true
        dataManager.fetchQuestionAnswerById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { questionAnswer in
                self.questionAnswer = questionAnswer
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func checkAnswer() {
        guard let questionAnswer = questionAnswer else { return }
        
        if selectedOption == questionAnswer.correctAnswer {
            alertMessage = questionAnswer.correctAnswerMessage
            updateUserTask(questionAnswer: questionAnswer)
        } else {
            alertMessage = questionAnswer.incorrectAnswerMessage
        }
        
        showResultModal = true
    }
    
    private func updateUserTask(questionAnswer: QuestionAnswer) {
        let activityType = "questionAnswer"
        var city: String? = nil
        
        if questionAnswer.isCapital {
            city = questionAnswer.province
        }

        updateUserTaskIDs(taskID: questionAnswer.id, activityType: activityType, city: city)
    }
}

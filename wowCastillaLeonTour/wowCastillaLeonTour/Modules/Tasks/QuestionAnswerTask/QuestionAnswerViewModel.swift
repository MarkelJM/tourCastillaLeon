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
        fetchUserProfile() // Cargar el perfil del usuario cuando se crea el ViewModel
        fetchQuestionAnswer()
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
            updateSpotForUser()
        } else {
            alertMessage = questionAnswer.incorrectAnswerMessage
        }
        
        showResultModal = true
    }
    
    private func updateUserTask(questionAnswer: QuestionAnswer) {
        updateTaskForUser(taskID: questionAnswer.id, challenge: questionAnswer.challenge)
    }

    private func updateTaskForUser(taskID: String, challenge: String) {
        firestoreManager.updateUserTaskIDs(taskID: taskID, challenge: challenge)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error actualizando la tarea: \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { _ in
                print("User task updated in Firestore")
            }
            .store(in: &cancellables)
    }

    private func updateSpotForUser() {
        if let spotID = userDefaultsManager.getSpotID() {
            firestoreManager.updateUserSpotIDs(spotID: spotID)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.alertMessage = "Error actualizando el spot: \(error.localizedDescription)"
                        self.showAlert = true
                    case .finished:
                        break
                    }
                } receiveValue: { _ in
                    print("User spot updated in Firestore")
                }
                .store(in: &cancellables)

            userDefaultsManager.clearSpotID()
        } else {
            print("No spotID found in UserDefaults")
        }
    }
}

/*
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
 fetchUserProfile() // Cargar el perfil del usuario cuando se crea el ViewModel
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
 let activityType = "questionAnswers"
 var city: String? = nil
 
 if questionAnswer.isCapital {
 city = questionAnswer.province
 }
 
 // Actualizar el reto asociado a la pregunta completada
 let challenge = questionAnswer.challenge
 updateUserTaskIDs(taskID: questionAnswer.id, activityType: activityType, city: city, challenge: challenge)
 }
 }
 */

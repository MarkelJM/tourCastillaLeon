//
//  DatesViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI
import Combine

class DatesOrderViewModel: BaseViewModel {
    @Published var dateEvent: DateEvent?
    @Published var isLoading: Bool = true
    @Published var shuffledOptions: [String] = []
    @Published var selectedEvents: [String] = []
    @Published var showResultAlert: Bool = false
    
    private let dataManager = DatesOrderDataManager()
    private var activityId: String
    var isCorrectOrder: Bool = false
    
    init(activityId: String) {
        self.activityId = activityId
        super.init()
        fetchUserProfile()
        fetchDateEvent()
    }
    
    func fetchDateEvent() {
        isLoading = true
        dataManager.fetchDateEventById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { dateEvent in
                self.dateEvent = dateEvent
                self.shuffledOptions = dateEvent.options.shuffled()
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func selectEvent(_ event: String) {
        selectedEvents.append(event)
    }
    
    func undoSelection() {
        if !selectedEvents.isEmpty {
            selectedEvents.removeLast()
        }
    }
    
    func checkAnswer() {
        guard let dateEvent = dateEvent else { return }
        
        if selectedEvents == dateEvent.correctAnswer {
            alertMessage = dateEvent.correctAnswerMessage
            isCorrectOrder = true
            updateUserTask(dateEvent: dateEvent)
            updateSpotForUser()
        } else {
            alertMessage = dateEvent.incorrectAnswerMessage
            isCorrectOrder = false
        }
        
        showResultAlert = true
    }
    
    private func updateUserTask(dateEvent: DateEvent) {
        updateTaskForUser(taskID: dateEvent.id, challenge: dateEvent.challenge)
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

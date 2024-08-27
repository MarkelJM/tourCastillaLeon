//
//  FillGapViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI
import Combine

class FillGapViewModel: BaseViewModel {
    @Published var fillGap: FillGap?
    @Published var isLoading: Bool = true
    @Published var userAnswers: [String] = []
    @Published var showResultAlert: Bool = false
    
    private let dataManager = FillGapDataManager()
    private var activityId: String
    
    init(activityId: String) {
        self.activityId = activityId
        super.init()
        fetchUserProfile()
        fetchFillGap()
    }
    
    func fetchFillGap() {
        isLoading = true
        dataManager.fetchFillGapById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { fillGap in
                self.fillGap = fillGap
                self.userAnswers = Array(repeating: "", count: fillGap.correctPositions.count)
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func submitAnswers() {
        guard let fillGap = fillGap else { return }
        
        if userAnswers == fillGap.correctPositions {
            alertMessage = fillGap.correctAnswerMessage
            updateUserTask(fillGap: fillGap)
            updateSpotForUser()
        } else {
            alertMessage = fillGap.incorrectAnswerMessage
        }
        
        showResultAlert = true
    }
    
    private func updateUserTask(fillGap: FillGap) {
        updateTaskForUser(taskID: fillGap.id, challenge: fillGap.challenge)
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

//
//  TakePhotoViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//


import SwiftUI
import Combine

class TakePhotoViewModel: BaseViewModel {
    @Published var takePhoto: TakePhoto?
    @Published var isLoading: Bool = true
    @Published var capturedImage: UIImage?
    @Published var showResultModal: Bool = false

    private let dataManager = TakePhotoDataManager()
    private var activityId: String
    private var appState: AppState

    init(activityId: String, appState: AppState) {
        self.activityId = activityId
        self.appState = appState
        super.init()
        fetchUserProfile()
        fetchTakePhoto()
    }

    func fetchTakePhoto() {
        isLoading = true
        dataManager.fetchTakePhotoById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { takePhoto in
                self.takePhoto = takePhoto
                self.isLoading = false
            }
            .store(in: &cancellables)
    }

    func checkTakePhoto(isCorrect: Bool) {
        guard let takePhoto = takePhoto else { return }

        if isCorrect && capturedImage != nil {
            alertMessage = takePhoto.correctAnswerMessage
            updateUserTask(takePhoto: takePhoto)
            updateSpotForUser()
        } else {
            alertMessage = takePhoto.incorrectAnswerMessage
        }

        showResultModal = true
    }

    private func updateUserTask(takePhoto: TakePhoto) {
        guard let user = user else { return }

        // Evitar duplicados
        if user.challenges[takePhoto.challenge]?.contains(takePhoto.id) == true {
            print("Task ID already exists, not adding again.")
            return
        }

        updateTaskForUser(taskID: takePhoto.id, challenge: takePhoto.challenge)
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
            } receiveValue: { [weak self] _ in
                print("User task updated in Firestore")
                self?.appState.currentView = .map
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


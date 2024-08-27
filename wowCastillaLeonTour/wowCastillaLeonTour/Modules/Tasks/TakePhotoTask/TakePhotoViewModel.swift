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
    @Published var capturedImage: UIImage? // Imagen capturada
    @Published var showResultModal: Bool = false
    
    private let dataManager = TakePhotoDataManager()
    private var activityId: String
    
    init(activityId: String) {
        self.activityId = activityId
        super.init()
        fetchUserProfile() // Cargar el perfil del usuario cuando se inicia el viewModel
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
        
        if isCorrect && capturedImage != nil { // Si hay una foto capturada
            alertMessage = takePhoto.correctAnswerMessage
            updateUserTask(takePhoto: takePhoto)
            updateSpotForUser()
        } else {
            alertMessage = takePhoto.incorrectAnswerMessage
        }
        
        showResultModal = true
    }
    
    private func updateUserTask(takePhoto: TakePhoto) {
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

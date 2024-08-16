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
        } else {
            alertMessage = takePhoto.incorrectAnswerMessage
        }
        
        showResultModal = true
    }
    
    private func updateUserTask(takePhoto: TakePhoto) {
        let activityType = "takePhoto"
        var city: String? = nil
        
        if takePhoto.isCapital {
            city = takePhoto.province
        }

        updateUserTaskIDs(taskID: takePhoto.id, activityType: activityType, city: city)
    }
}

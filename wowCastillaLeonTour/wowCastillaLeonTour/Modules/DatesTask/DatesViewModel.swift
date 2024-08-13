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
        fetchUserProfile() // Cargar el perfil del usuario cuando se inicia el viewModel
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
    
    func checkAnswer() {
        guard let dateEvent = dateEvent else { return }
        
        if selectedEvents == dateEvent.correctAnswer {
            alertMessage = dateEvent.correctAnswerMessage
            isCorrectOrder = true
            updateUserTask(dateEvent: dateEvent)
        } else {
            alertMessage = dateEvent.incorrectAnswerMessage
            isCorrectOrder = false
        }
        
        showResultAlert = true
    }
    
    private func updateUserTask(dateEvent: DateEvent) {
        let activityType = "dateEvent"
        var city: String? = nil
        
        if dateEvent.isCapital {
            city = dateEvent.province
        }

        updateUserTaskIDs(taskID: dateEvent.id, activityType: activityType, city: city)
    }
}

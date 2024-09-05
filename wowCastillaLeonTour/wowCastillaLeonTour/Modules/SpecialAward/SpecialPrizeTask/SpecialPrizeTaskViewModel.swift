//
//  SpecialPrizeTaskViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//
/*
import SwiftUI
import Combine

class SpecialPrizeTaskViewModel: BaseViewModel {
    @Published var specialPrize: SpecialPrize?
    @Published var showResultModal: Bool = false
    
    private let dataManager = SpecialPrizeTaskDataManager()
    
    init(prizeId: String) {
        super.init()
        fetchSpecialPrize(by: prizeId)
    }
    
    func fetchSpecialPrize(by id: String) {
        dataManager.fetchSpecialPrizeById(by: id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { specialPrize in
                self.specialPrize = specialPrize
            }
            .store(in: &self.cancellables)
    }
    
    func completeSpecialTask() {
        guard let prize = specialPrize else { return }
        
        // Lógica para añadir el SpecialPrize al array specialRewards en el perfil del usuario
        updateUserTaskIDs(taskID: prize.id, activityType: "specialPrize", city: prize.province)
        
        // Mostrar mensaje correcto
        alertMessage = prize.correctAnswerMessage
        showResultModal = true
    }
}
*/

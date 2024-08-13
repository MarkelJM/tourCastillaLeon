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
        } else {
            alertMessage = fillGap.incorrectAnswerMessage
        }
        
        showResultAlert = true
    }
    
    private func updateUserTask(fillGap: FillGap) {
        let activityType = "fillGap"
        var city: String? = nil
        
        if fillGap.isCapital {
            city = fillGap.province
        }

        updateUserTaskIDs(taskID: fillGap.id, activityType: activityType, city: city)
    }
}

//
//  FillGapViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI
import Combine

class FillGapViewModel: ObservableObject {
    @Published var fillGaps: [FillGap] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = true

    private var cancellables = Set<AnyCancellable>()
    private let dataManager = FillGapDataManager()
    private let activityId: String

    init(activityId: String) {
        self.activityId = activityId
        fetchFillGapById(activityId)
    }

    func fetchFillGapById(_ id: String) {
        isLoading = true
        dataManager.fetchFillGapById(id)
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
                self.fillGaps = [fillGap]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}

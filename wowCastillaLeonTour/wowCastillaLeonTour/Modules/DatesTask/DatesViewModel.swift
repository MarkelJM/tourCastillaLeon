//
//  DatesViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI
import Combine

class DatesViewModel: ObservableObject {
    @Published var dates: [DateActivity] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = true

    private var cancellables = Set<AnyCancellable>()
    private let dataManager = DatesDataManager()
    private let activityId: String

    init(activityId: String) {
        self.activityId = activityId
        fetchDateActivityById(activityId)
    }

    func fetchDateActivityById(_ id: String) {
        isLoading = true
        dataManager.fetchDateActivityById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { dateActivity in
                self.dates = [dateActivity]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}

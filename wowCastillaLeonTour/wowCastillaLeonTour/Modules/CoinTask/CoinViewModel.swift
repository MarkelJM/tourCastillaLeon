//
//  CoinViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI
import Combine

class CoinViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = true

    private var cancellables = Set<AnyCancellable>()
    private let dataManager = CoinDataManager()
    private let activityId: String

    init(activityId: String) {
        self.activityId = activityId
        fetchCoinById(activityId)
    }

    func fetchCoinById(_ id: String) {
        isLoading = true
        dataManager.fetchCoinById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { coin in
                self.coins = [coin]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}

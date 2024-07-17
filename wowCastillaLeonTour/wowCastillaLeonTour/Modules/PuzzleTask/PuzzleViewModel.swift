//
//  PuzzleViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 17/7/24.
//

import Foundation
import Combine

class PuzzleViewModel: ObservableObject {
    @Published var puzzles: [Puzzle] = []
    @Published var errorMessage: String?
    private var dataManager = PuzzleDataManager()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPuzzles() {
        dataManager.fetchPuzzles()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] puzzles in
                self?.puzzles = puzzles
            }
            .store(in: &cancellables)
    }
}

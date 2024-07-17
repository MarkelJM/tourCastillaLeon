//
//  PuzzleViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 17/7/24.
//

import Foundation
import Combine
import CoreGraphics

class PuzzleViewModel: ObservableObject {
    @Published var puzzles: [Puzzle] = []
    @Published var errorMessage: String?
    @Published var piecePositions: [String: CGPoint] = [:] 
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
    
    func checkPuzzleSolution(for puzzle: Puzzle, tolerance: CGFloat) -> Bool {
        for (key, correctPosition) in puzzle.correctPositions {
            guard let currentPosition = piecePositions[key] else { return false }
            let dx = abs(currentPosition.x - CGFloat(correctPosition["x"] ?? 0))
            let dy = abs(currentPosition.y - CGFloat(correctPosition["y"] ?? 0))
            if dx > tolerance || dy > tolerance {
                return false
            }
        }
        return true
    }
}

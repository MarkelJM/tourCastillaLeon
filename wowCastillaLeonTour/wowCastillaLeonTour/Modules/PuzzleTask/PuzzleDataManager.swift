//
//  PuzzleDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 17/7/24.
//

import Foundation
import Combine

class PuzzleDataManager {
    private let firestoreManager = PuzzleFirestoreManager()
    
    func fetchPuzzles() -> AnyPublisher<[Puzzle], Error> {
        Future { [weak self] promise in
            self?.firestoreManager.fetchPuzzles { result in
                switch result {
                case .success(let puzzles):
                    promise(.success(puzzles))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

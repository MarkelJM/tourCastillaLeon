//
//  PuzzleFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 17/7/24.
//

import Combine
import FirebaseFirestore

class PuzzleFirestoreManager {
    private let db = Firestore.firestore()
    
    func fetchPuzzleById(_ id: String) -> AnyPublisher<Puzzle, Error> {
        Future { promise in
            self.db.collection("puzzles").document(id).getDocument { document, error in
                if let document = document, document.exists {
                    if let data = document.data(), let puzzle = Puzzle(from: data) {
                        promise(.success(puzzle))
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No puzzle found"])))
                    }
                } else {
                    promise(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

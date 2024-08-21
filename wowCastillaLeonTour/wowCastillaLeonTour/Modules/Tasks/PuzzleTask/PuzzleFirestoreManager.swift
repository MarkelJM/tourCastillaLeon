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
                if let document = document, document.exists, let data = document.data() {
                    print("Fetched data: \(data)") // Agregar este print para depuración
                    if let puzzle = Puzzle(from: data) {
                        promise(.success(puzzle))
                    } else {
                        print("Failed to decode puzzle with data: \(data)") // Agregar este print para depuración
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode puzzle"])))
                    }
                } else {
                    promise(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

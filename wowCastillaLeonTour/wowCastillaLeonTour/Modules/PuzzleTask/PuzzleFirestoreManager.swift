//
//  PuzzleFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 17/7/24.
//

import Foundation
import FirebaseFirestore
import Combine


class PuzzleFirestoreManager {
    private let db = Firestore.firestore()
    
    func fetchPuzzleById(_ id: String) -> AnyPublisher<Puzzle, Error> {
       Future { promise in
           self.db.collection("puzzles").document(id).getDocument { snapshot, error in
               if let error = error {
                   promise(.failure(error))
               } else if let data = snapshot?.data(), let puzzle = Puzzle(from: data) {
                   promise(.success(puzzle))
               } else {
                   promise(.failure(NSError(domain: "Document not found", code: 404, userInfo: nil)))
               }
           }
       }
       .eraseToAnyPublisher()
   }
    
    func fetchPuzzles(completion: @escaping (Result<[Puzzle], Error>) -> Void) {
        db.collection("puzzles").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let puzzles = querySnapshot?.documents.compactMap { document in
                    Puzzle(from: document.data())
                } ?? []
                completion(.success(puzzles))
            }
        }
    }
    
    
    
    
}

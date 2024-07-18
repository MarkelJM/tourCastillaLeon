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

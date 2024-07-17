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
        db.collection("puzzles").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let puzzles = snapshot.documents.compactMap { document -> Puzzle? in
                    let data = document.data()
                    return Puzzle(from: data)
                }
                completion(.success(puzzles))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected error"])))
            }
        }
    }
}

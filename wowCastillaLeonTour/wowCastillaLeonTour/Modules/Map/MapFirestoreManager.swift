//
//  MapFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import FirebaseFirestore

class MapFirestoreManager {
    private var db = Firestore.firestore()
    
    func fetchPoints(completion: @escaping (Result<[Point], Error>) -> Void) {
        db.collection("points").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let points = querySnapshot?.documents.compactMap { document in
                    Point(from: document.data())
                } ?? []
                completion(.success(points))
            }
        }
    }
}

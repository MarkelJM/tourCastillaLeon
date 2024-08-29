//
//  MapFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//


import FirebaseFirestore
import Combine

class MapFirestoreManager {
    private var db = Firestore.firestore()

    func fetchSpots(for challengeName: String) -> AnyPublisher<[Spot], Error> {
        Future { promise in
            self.db.collection("spots")
                .document(challengeName)
                .collection("locationsSpot")
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        let spots = querySnapshot?.documents.compactMap { document in
                            Spot(from: document.data())
                        } ?? []
                        promise(.success(spots))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    func fetchChallengeReward(for challengeName: String) -> AnyPublisher<ChallengeReward, Error> {
        Future { promise in
            self.db.collection("challengeRewards")
                .document(challengeName)
                .getDocument { document, error in
                    if let document = document, document.exists {
                        if let rewardData = document.data(), let reward = ChallengeReward(from: rewardData) {
                            promise(.success(reward))
                        } else {
                            promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse ChallengeReward"])))
                        }
                    } else {
                        promise(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}

/*
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
*/

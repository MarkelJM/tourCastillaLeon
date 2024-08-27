//
//  MapFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//


import FirebaseFirestore

class MapFirestoreManager {
    private var db = Firestore.firestore()
    
    func fetchSpots(for challengeName: String, completion: @escaping (Result<[Spot], Error>) -> Void) {
        db.collection("spots")
            .document(challengeName)
            .collection("locationsSpot")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let spots = querySnapshot?.documents.compactMap { document in
                        Spot(from: document.data())
                    } ?? []
                    completion(.success(spots))
                }
            }
    }

    func fetchChallengeReward(for challengeName: String, completion: @escaping (Result<ChallengeReward, Error>) -> Void) {
        db.collection("challengeRewards")
            .document(challengeName)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    if let rewardData = document.data(), let reward = ChallengeReward(from: rewardData) {
                        completion(.success(reward))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse ChallengeReward"])))
                    }
                } else {
                    completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
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

//
//  ChallengeListFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/8/24.
//



import Combine
import FirebaseFirestore

class ChallengeListFirestoreManager {
    private let db = Firestore.firestore()

    func fetchChallenges() -> AnyPublisher<[Challenge], Error> {
        Future { promise in
            self.db.collection("challenges").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching challenges: \(error.localizedDescription)")  
                    promise(.failure(error))
                } else {
                    let challenges = snapshot?.documents.compactMap { document in
                        return Challenge(from: document.data())
                    } ?? []
                    print("Challenges fetched: \(challenges)")
                    promise(.success(challenges))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

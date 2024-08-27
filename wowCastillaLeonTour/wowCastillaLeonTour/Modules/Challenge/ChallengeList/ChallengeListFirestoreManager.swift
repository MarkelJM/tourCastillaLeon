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
                    promise(.failure(error))
                } else {
                    let challenges = snapshot?.documents.compactMap { document in
                        Challenge(from: document.data())
                    } ?? []
                    promise(.success(challenges))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

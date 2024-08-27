//
//  SpecialPrizeFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//
/*
import Combine
import FirebaseFirestore

class SpecialPrizeFirestoreManager {
    private let db = Firestore.firestore()

    func fetchSpecialPrizes() -> AnyPublisher<[SpecialPrize], Error> {
        Future { promise in
            self.db.collection("capitalPrize").getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let documents = snapshot?.documents {
                    let specialPrizes = documents.compactMap { document -> SpecialPrize? in
                        SpecialPrize(from: document.data())
                    }
                    promise(.success(specialPrizes))
                } else {
                    promise(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
*/

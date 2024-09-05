//
//  SpecialPrizeTaskFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//
/*
import Combine
import FirebaseFirestore

class SpecialPrizeTaskFirestoreManager {
    private let db = Firestore.firestore()

    func fetchSpecialPrizeById(_ id: String) -> AnyPublisher<SpecialPrize, Error> {
        Future { promise in
            self.db.collection("capitalPrize").document(id).getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = document?.data(), let specialPrize = SpecialPrize(from: data) {
                    promise(.success(specialPrize))
                } else {
                    promise(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
*/

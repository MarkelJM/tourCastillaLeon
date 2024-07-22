//
//  DatesFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Foundation
import Combine
import FirebaseFirestore

class DatesFirestoreManager {
    private let db = Firestore.firestore()

    func fetchDateEventById(_ id: String) -> AnyPublisher<DateEvent, Error> {
        Future { promise in
            self.db.collection("dates").document(id).getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = snapshot?.data(), let dateEvent = DateEvent(from: data) {
                    promise(.success(dateEvent))
                } else {
                    promise(.failure(NSError(domain: "Document not found", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

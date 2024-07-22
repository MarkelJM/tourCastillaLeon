//
//  FillGapFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Foundation
import Combine
import FirebaseFirestore

class FillGapFirestoreManager {
    private let db = Firestore.firestore()

    func fetchFillGapById(_ id: String) -> AnyPublisher<FillGap, Error> {
        Future { promise in
            self.db.collection("fillGap").document(id).getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = snapshot?.data(), let fillGap = FillGap(from: data) {
                    promise(.success(fillGap))
                } else {
                    promise(.failure(NSError(domain: "Document not found", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

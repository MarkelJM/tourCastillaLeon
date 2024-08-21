//
//  DatesFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Foundation
import Combine
import FirebaseFirestore

class DatesOrderFirestoreManager {
    private let db = Firestore.firestore()
    
    func fetchDateEventById(_ id: String) -> AnyPublisher<DateEvent, Error> {
        Future { promise in
            self.db.collection("dates").document(id).getDocument { document, error in
                if let document = document, document.exists, let data = document.data() {
                    if let dateEvent = DateEvent(from: data) {
                        promise(.success(dateEvent))
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode dateEvent"])))
                    }
                } else {
                    promise(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

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
    private let collectionName = "dates" 

    func fetchDateEventById(_ id: String) -> AnyPublisher<DateEvent, Error> {
        let subject = PassthroughSubject<DateEvent, Error>()
        
        db.collection(collectionName).document(id).getDocument { document, error in
            if let error = error {
                subject.send(completion: .failure(error))
            } else if let document = document, document.exists, let data = document.data() {
                if let dateEvent = DateEvent(from: data) {
                    subject.send(dateEvent)
                } else {
                    subject.send(completion: .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse DateEvent"])))
                }
            } else {
                subject.send(completion: .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
}

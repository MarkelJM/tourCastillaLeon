//
//  TakePhotoFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Foundation
import Combine
import FirebaseFirestore

class TakePhotoFirestoreManager {
    private let db = Firestore.firestore()

    func fetchTakePhotoById(_ id: String) -> AnyPublisher<TakePhoto, Error> {
        Future { promise in
            self.db.collection("takePhotos").document(id).getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = snapshot?.data(), let takePhoto = TakePhoto(from: data) {
                    promise(.success(takePhoto))
                } else {
                    promise(.failure(NSError(domain: "Document not found", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

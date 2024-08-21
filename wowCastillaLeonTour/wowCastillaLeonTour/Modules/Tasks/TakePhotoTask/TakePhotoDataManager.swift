//
//  TakePhotoDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Foundation
import Combine

class TakePhotoDataManager {
    private let firestoreManager = TakePhotoFirestoreManager()
    
    func fetchTakePhotoById(_ id: String) -> AnyPublisher<TakePhoto, Error> {
        return firestoreManager.fetchTakePhotoById(id)
    }
}

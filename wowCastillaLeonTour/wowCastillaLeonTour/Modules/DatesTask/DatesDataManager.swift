//
//  DatesDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Foundation
import Combine

class DatesDataManager {
    private let firestoreManager = DatesFirestoreManager()
    
    func fetchDateEventById(_ id: String) -> AnyPublisher<DateEvent, Error> {
        return firestoreManager.fetchDateEventById(id)
    }
}

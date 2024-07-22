//
//  FillGapDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Foundation
import Combine

class FillGapDataManager {
    private let firestoreManager = FillGapFirestoreManager()
    
    func fetchFillGapById(_ id: String) -> AnyPublisher<FillGap, Error> {
        return firestoreManager.fetchFillGapById(id)
    }
}

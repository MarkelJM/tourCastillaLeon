//
//  SpecialPrizeTaskDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//

import Combine

class SpecialPrizeTaskDataManager {
    private let firestoreManager = SpecialPrizeTaskFirestoreManager()
    
    func fetchSpecialPrizeById(by id: String) -> AnyPublisher<SpecialPrize, Error> {
        return firestoreManager.fetchSpecialPrizeById(id)
    }
}

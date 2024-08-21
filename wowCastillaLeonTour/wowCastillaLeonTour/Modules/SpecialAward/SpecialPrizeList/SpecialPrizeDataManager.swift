//
//  SpecialPrizeDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//

import Combine

class SpecialPrizeDataManager {
    private let firestoreManager = SpecialPrizeFirestoreManager()
    
    func fetchSpecialPrizes() -> AnyPublisher<[SpecialPrize], Error> {
        return firestoreManager.fetchSpecialPrizes()
    }
}

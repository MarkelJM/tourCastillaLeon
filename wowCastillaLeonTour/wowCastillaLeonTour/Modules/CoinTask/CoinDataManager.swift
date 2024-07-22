//
//  CoinDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Combine
import FirebaseFirestore


class CoinDataManager {
    private let firestoreManager = CoinFirestoreManager()
    
    func fetchCoinById(_ id: String) -> AnyPublisher<Coin, Error> {
        return firestoreManager.fetchCoinById(id)
    }
}

//
//  MapDatamanager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation
import Combine

class MapDataManager {
    private let firestoreManager = MapFirestoreManager()
    
    func fetchSpots(for challengeName: String) -> AnyPublisher<[Spot], Error> {
        return firestoreManager.fetchSpots(for: challengeName)
    }

    func fetchChallenges() -> AnyPublisher<[Challenge], Error> {
        return firestoreManager.fetchChallenges()
    }

    func fetchChallengeReward(for challengeName: String) -> AnyPublisher<ChallengeReward, Error> {
        return firestoreManager.fetchChallengeReward(for: challengeName)
    }
}

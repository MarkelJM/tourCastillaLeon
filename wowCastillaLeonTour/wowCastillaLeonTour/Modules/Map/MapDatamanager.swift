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
        Future { promise in
            self.firestoreManager.fetchSpots(for: challengeName) { result in
                switch result {
                case .success(let spots):
                    promise(.success(spots))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchChallengeReward(for challengeName: String) -> AnyPublisher<ChallengeReward, Error> {
        Future { promise in
            self.firestoreManager.fetchChallengeReward(for: challengeName) { result in
                switch result {
                case .success(let reward):
                    promise(.success(reward))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

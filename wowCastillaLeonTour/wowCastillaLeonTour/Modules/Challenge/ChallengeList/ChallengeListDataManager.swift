//
//  ChallengeListDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/8/24.
//

import Combine

class ChallengeListDataManager {
    private let firestoreManager = ChallengeListFirestoreManager()

    func fetchChallenges() -> AnyPublisher<[Challenge], Error> {
        return firestoreManager.fetchChallenges()
    }
}

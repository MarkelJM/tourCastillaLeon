//
//  ChallengePresentationDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/8/24.
//

import Combine

class ChallengePresentationDataManager {
    private let firestoreManager = ChallengePresentationFirestoreManager()

    func updateChallengeStatus(challengeID: String, isBegan: Bool) -> AnyPublisher<Void, Error> {
        return firestoreManager.updateChallengeStatus(challengeID: challengeID, isBegan: isBegan)
    }

    func fetchChallengeByName(_ name: String) -> AnyPublisher<Challenge, Error> {
        return firestoreManager.fetchChallengeByName(name)
    }
}

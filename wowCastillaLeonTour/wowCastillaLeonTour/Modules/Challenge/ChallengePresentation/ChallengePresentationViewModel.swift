//
//  ChallengePresentationViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/8/24.
//

import SwiftUI
import Combine

class ChallengePresentationViewModel: BaseViewModel {
    @Published var challenge: Challenge?
    private let dataManager = ChallengePresentationDataManager()
    private var challengeName: String

    init(challengeName: String) {
        self.challengeName = challengeName
        super.init()
        fetchChallenge()
        fetchUserProfile()
    }

    var userAvatar: String {
        user?.avatar.rawValue ?? "defaultAvatar"
    }

    func beginChallenge() {
        guard var challenge = challenge else { return }
        challenge.isBegan = true
        updateChallengeStatus(challenge: challenge)
    }

    private func fetchChallenge() {
        dataManager.fetchChallengeByName(challengeName)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error loading challenge: \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] challenge in
                self?.challenge = challenge
            }
            .store(in: &cancellables)
    }

    private func updateChallengeStatus(challenge: Challenge) {
        dataManager.updateChallengeStatus(challengeID: challenge.id, isBegan: challenge.isBegan)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error updating challenge status: \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    self.alertMessage = "Challenge started successfully."
                    self.showAlert = true
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

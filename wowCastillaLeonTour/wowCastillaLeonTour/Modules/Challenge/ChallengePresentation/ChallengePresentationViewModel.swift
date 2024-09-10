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

    func beginChallenge() -> AnyPublisher<Void, Error> {
        guard let challenge = challenge, var user = user else {
            return Fail(error: NSError(domain: "No user or challenge available", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        // adding challengeName if is empty
        if user.challenges[challengeName] == nil {
            user.challenges[challengeName] = [] // INITIAL EMPTY ARRAY
        }

        // saves challengename in userdefaul to use in maocontainer
        userDefaultsManager.saveChallengeName(challengeName)

        
        return saveUserChallengeState(user: user)
            .handleEvents(receiveOutput: {
                print("Challenge state saved in Firestore")
            })
            .eraseToAnyPublisher()
    }

    private func saveUserChallengeState(user: User) -> AnyPublisher<Void, Error> {
        return firestoreManager.updateUserChallenges(user: user)
    }

    private func fetchChallenge() {
        dataManager.fetchChallengeByName(challengeName)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
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
}

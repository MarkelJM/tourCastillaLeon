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
        
        // Añadir el nombre del desafío al diccionario challenges si no está presente
        if user.challenges[challengeName] == nil {
            user.challenges[challengeName] = [] // Inicializar con un array vacío
        }

        // Guardar el nombre del desafío en UserDefaults
        userDefaultsManager.saveChallengeName(challengeName)

        // Guardar el estado actualizado del desafío en Firestore
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

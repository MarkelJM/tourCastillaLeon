//
//  ChallengeListViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/8/24.
//

import SwiftUI
import Combine

class ChallengeListViewModel: BaseViewModel {
    @Published var challenges: [Challenge] = []
    @Published var selectedChallengeId: String?
    @Published var isUserLoaded: Bool = false

    private let dataManager = ChallengeListDataManager()

    override init() {
        super.init()
        fetchUserProfile() // Asegúrate de cargar el perfil del usuario al iniciar
    }
    
    override func fetchUserProfile() {
        super.fetchUserProfile()
        self.$user
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.isUserLoaded = true
            }
            .store(in: &self.cancellables)
    }
    
    func fetchChallenges() {
        dataManager.fetchChallenges()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { challenges in
                self.challenges = challenges
            }
            .store(in: &self.cancellables)
    }
    
    func completedTasks(for challengeName: String) -> Int {
        guard let user = user else { return 0 }
        return user.challenges[challengeName]?.count ?? 0
    }

    func selectChallenge(_ challenge: Challenge) {
        self.selectedChallengeId = challenge.id
    }

    func isChallengeAlreadyBegan(challengeName: String) -> Bool {
        guard let user = user else { return false }
        return user.challenges[challengeName] != nil
    }
}

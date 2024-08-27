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
        fetchUserProfile()
    }
    
    override func fetchUserProfile() {
        super.fetchUserProfile()
        self.$user
            .compactMap { $0 }
            .sink { [weak self] user in
                print("User loaded: \(String(describing: user))")  // Imprimir los datos del usuario cargado
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
                    print("Error in fetchChallenges: \(error.localizedDescription)")  // Imprimir el error
                    self.errorMessage = error.localizedDescription
                case .finished:
                    print("Finished fetching challenges.")  // Indicar que la operación ha terminado
                }
            } receiveValue: { challenges in
                print("Challenges received: \(challenges)")  // Imprimir los desafíos recibidos
                self.challenges = challenges
            }
            .store(in: &self.cancellables)
    }
    
    func completedTasks(for challengeName: String) -> Int {
        guard let user = user else { return 0 }
        return user.challenges[challengeName]?.count ?? 0
    }

    func selectChallenge(_ challenge: Challenge) {
        print("Selected challenge: \(challenge)")  // Imprimir el desafío seleccionado
        self.selectedChallengeId = challenge.id
    }

    func isChallengeAlreadyBegan(challengeName: String) -> Bool {
        guard let user = user else { return false }
        let hasBegan = user.challenges[challengeName] != nil
        print("Challenge \(challengeName) already began: \(hasBegan)")  // Imprimir si el desafío ya comenzó
        return hasBegan
    }
}

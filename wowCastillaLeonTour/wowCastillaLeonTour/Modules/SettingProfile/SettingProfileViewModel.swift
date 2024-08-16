//
//  SettingProfileViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 16/8/24.
//

import SwiftUI
import Combine

class SettingProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let dataManager = SettingProfileDataManager()
    var cancellables = Set<AnyCancellable>()

    func fetchUserProfile() {
        dataManager.fetchUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }
    
    func updateUserName(_ newName: String) {
        guard var user = user else { return }
        user.firstName = newName
        updateUserProfile(user: user)
    }

    private func updateUserProfile(user: User) {
        dataManager.updateUserProfile(user: user)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error updating user profile: \(error.localizedDescription)")
                case .finished:
                    print("User profile updated successfully")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

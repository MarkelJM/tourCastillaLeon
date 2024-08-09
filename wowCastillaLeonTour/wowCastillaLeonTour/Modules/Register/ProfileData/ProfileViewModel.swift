//
//  ProfileViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//

import Foundation
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date = Date()
    @Published var postalCode: String = ""
    @Published var city: String = ""
    @Published var province: Province = .other
    @Published var avatar: Avatar = .boy
    @Published var taskIDs: [String] = []
    @Published var coinTaskIDs: [String] = []
    @Published var gadgetTaskIDs: [String] = []
    @Published var usedCoinTaskIDs: [String] = []
    @Published var specialRewards: [String] = []
    @Published var avilaCityTaskIDs: [String] = []
    @Published var burgosCityTaskIDs: [String] = []
    @Published var leonCityTaskIDs: [String] = []
    @Published var palenciaCityTaskIDs: [String] = []
    @Published var salamancaCityTaskIDs: [String] = []
    @Published var segoviaCityTaskIDs: [String] = []
    @Published var soriaCityTaskIDs: [String] = []
    @Published var valladolidCityTaskIDs: [String] = []
    @Published var zamoraCityTaskIDs: [String] = []
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var navigateToAvatarSelection: Bool = false
    
    private let dataManager = ProfileDataManager()
    private var cancellables = Set<AnyCancellable>()
    @EnvironmentObject var appState: AppState

    
    func saveUserProfile() {
        let user = User(
            id: UUID().uuidString,
            email: email,
            firstName: firstName,
            lastName: lastName,
            birthDate: birthDate,
            postalCode: postalCode,
            city: city,
            province: province,
            avatar: avatar,
            taskIDs: taskIDs,
            coinTaskIDs: coinTaskIDs,
            gadgetTaskIDs: gadgetTaskIDs,
            usedCoinTaskIDs: usedCoinTaskIDs,
            specialRewards: specialRewards,
            avilaCityTaskIDs: avilaCityTaskIDs,
            burgosCityTaskIDs: burgosCityTaskIDs,
            leonCityTaskIDs: leonCityTaskIDs,
            palenciaCityTaskIDs: palenciaCityTaskIDs,
            salamancaCityTaskIDs: salamancaCityTaskIDs,
            segoviaCityTaskIDs: segoviaCityTaskIDs,
            soriaCityTaskIDs: soriaCityTaskIDs,
            valladolidCityTaskIDs: valladolidCityTaskIDs,
            zamoraCityTaskIDs: zamoraCityTaskIDs
        )
        
        dataManager.createUserProfile(user: user)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: {
                self.appState.currentView = .map
            }
            .store(in: &cancellables)
    }
    
    func fetchUserProfile() {
        dataManager.fetchUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { user in
                self.email = user.email
                self.firstName = user.firstName
                self.lastName = user.lastName
                self.birthDate = user.birthDate
                self.postalCode = user.postalCode
                self.city = user.city
                self.province = user.province
                self.avatar = user.avatar
                self.taskIDs = user.taskIDs
                self.coinTaskIDs = user.coinTaskIDs
                self.gadgetTaskIDs = user.gadgetTaskIDs
                self.usedCoinTaskIDs = user.usedCoinTaskIDs
                self.specialRewards = user.specialRewards
                self.avilaCityTaskIDs = user.avilaCityTaskIDs
                self.burgosCityTaskIDs = user.burgosCityTaskIDs
                self.leonCityTaskIDs = user.leonCityTaskIDs
                self.palenciaCityTaskIDs = user.palenciaCityTaskIDs
                self.salamancaCityTaskIDs = user.salamancaCityTaskIDs
                self.segoviaCityTaskIDs = user.segoviaCityTaskIDs
                self.soriaCityTaskIDs = user.soriaCityTaskIDs
                self.valladolidCityTaskIDs = user.valladolidCityTaskIDs
                self.zamoraCityTaskIDs = user.zamoraCityTaskIDs
            }
            .store(in: &cancellables)
    }
    
    func navigateToAvatarSelectionView() {
        navigateToAvatarSelection = true
    }
}

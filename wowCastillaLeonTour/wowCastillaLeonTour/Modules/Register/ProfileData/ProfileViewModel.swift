//
//  ProfileViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date = Date()
    @Published var postalCode: String = ""
    @Published var city: String = ""
    @Published var province: Province = .other
    @Published var avatar: Avatar = .boy
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var navigateToAvatarSelection: Bool = false // Nueva propiedad

    private let dataManager = ProfileDataManager()
    
    func saveUserProfile() {
        let user = User(id: UUID().uuidString, email: email, firstName: firstName, lastName: lastName, birthDate: birthDate, postalCode: postalCode, city: city, province: province, avatar: avatar)
        dataManager.createUserProfile(user: user) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    // Navegar a la vista deseada
                }
            case .failure(let error):
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchUserProfile() {
        dataManager.fetchUserProfile { [weak self] result in
            switch result {
            case .success(let user):
                self?.email = user.email
                self?.firstName = user.firstName
                self?.lastName = user.lastName
                self?.birthDate = user.birthDate
                self?.postalCode = user.postalCode
                self?.city = user.city
                self?.province = user.province
                self?.avatar = user.avatar
            case .failure(let error):
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func navigateToAvatarSelectionView() {
        navigateToAvatarSelection = true
    }
}

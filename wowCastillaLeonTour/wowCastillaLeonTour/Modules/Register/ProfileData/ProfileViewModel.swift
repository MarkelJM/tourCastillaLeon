//
//  ProfileViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

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

    private let firestoreManager = FirestoreManager()
    
    func saveUserProfile() {
        let user = User(id: UUID().uuidString, email: email, firstName: firstName, lastName: lastName, birthDate: birthDate, postalCode: postalCode, city: city, province: province, avatar: avatar)
        firestoreManager.createUserProfile(user: user) { [weak self] result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    // Navegar a avatar
                }
            case .failure(let error):
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}

//
//  RegisterViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var showVerificationModal: Bool = false
    @Published var isVerified: Bool = false

    private let auth = Auth.auth()

    func register() {
        guard password == repeatPassword else {
            showError = true
            errorMessage = "Las contraseñas no coinciden"
            return
        }

        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            } else {
                self?.sendEmailVerification()
            }
        }
    }

    private func sendEmailVerification() {
        auth.currentUser?.sendEmailVerification { [weak self] error in
            if let error = error {
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            } else {
                self?.showVerificationModal = true
            }
        }
    }

    func checkEmailVerification() {
        auth.currentUser?.reload(completion: { [weak self] error in
            if let error = error {
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            } else if self?.auth.currentUser?.isEmailVerified == true {
                self?.isVerified = true
            } else {
                self?.showError = true
                self?.errorMessage = "Por favor, verifica tu correo electrónico"
            }
        })
    }
}

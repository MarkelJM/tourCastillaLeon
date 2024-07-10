//
//  RegisterViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var showVerificationModal: Bool = false
    @Published var isVerified: Bool = false
    
    private let dataManager = RegisterDataManager()

    func register() {
        guard password == repeatPassword else {
            showError = true
            errorMessage = "Las contraseñas no coinciden"
            return
        }

        dataManager.registerUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.sendEmailVerification()
            case .failure(let error):
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    private func sendEmailVerification() {
        dataManager.sendEmailVerification { [weak self] result in
            switch result {
            case .success:
                self?.showVerificationModal = true
            case .failure(let error):
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    func checkEmailVerification() {
        dataManager.checkEmailVerification { [weak self] result in
            switch result {
            case .success(let isVerified):
                if isVerified {
                    self?.isVerified = true
                } else {
                    self?.showError = true
                    self?.errorMessage = "Por favor, verifica tu correo electrónico"
                }
            case .failure(let error):
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}

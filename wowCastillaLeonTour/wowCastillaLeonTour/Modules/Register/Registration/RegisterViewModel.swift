//
//  RegisterViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import Foundation
import Combine
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var showVerificationModal: Bool = false
    @Published var isVerified: Bool = false

    let registrationSuccess = PassthroughSubject<Void, Never>()

    private let dataManager = RegisterDataManager()
    private var cancellables = Set<AnyCancellable>()

    func register() {
        guard password == repeatPassword else {
            showError = true
            errorMessage = "Las contraseñas no coinciden"
            return
        }

        dataManager.registerUser(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showError = true
                    if let authError = error as NSError?, let errorCode = AuthErrorCode(rawValue: authError.code) {
                        switch errorCode {
                        case .invalidEmail:
                            self.errorMessage = "El correo electrónico no es válido."
                        case .emailAlreadyInUse:
                            self.errorMessage = "Este correo electrónico ya está en uso."
                        case .weakPassword:
                            self.errorMessage = "La contraseña es demasiado débil."
                        default:
                            self.errorMessage = "Error: \(authError.localizedDescription)"
                        }
                    } else {
                        self.errorMessage = "Error desconocido: \(error.localizedDescription)"
                    }
                case .finished:
                    self.sendEmailVerification() // Enviar email de verificación después de registrarse
                }
            } receiveValue: {
                // Acciones adicionales después del registro
            }
            .store(in: &cancellables)
    }

    private func sendEmailVerification() {
        dataManager.sendEmailVerification()
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
                self.showVerificationModal = true
            }
            .store(in: &cancellables)
    }

    func checkEmailVerification() {
        dataManager.checkEmailVerification()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { isVerified in
                if isVerified {
                    self.isVerified = true
                } else {
                    self.showError = true
                    self.errorMessage = "Por favor, verifica tu correo electrónico"
                }
            }
            .store(in: &cancellables)
    }
}

//
//  LoginViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//


import Foundation
import Combine
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    let loginSuccess = PassthroughSubject<Void, Never>()
    
    private let dataManager = LoginDataManager()
    private var cancellables = Set<AnyCancellable>()

    func login() {
        // Acceso directo con credenciales 123
        if email == "123" && password == "123" {
            loginSuccess.send(())
            return
        }
        
        dataManager.loginUser(email: email, password: password)
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
                // Guardar el UID en Keychain
                if let uid = Auth.auth().currentUser?.uid {
                    KeychainManager.shared.save(key: "userUID", value: uid)
                }
                self.loginSuccess.send(())
            }
            .store(in: &cancellables)
    }
}


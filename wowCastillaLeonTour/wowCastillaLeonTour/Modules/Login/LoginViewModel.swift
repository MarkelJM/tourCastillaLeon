//
//  LoginViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var currentView: AppState.AppView?

    private let dataManager = LoginDataManager()

    func login() {
        
        dataManager.loginUser(email: email, password: password) { [weak self] result in
            switch result {
                
            case .success:
                ///NAVEGAR A HOME
                self?.currentView = .map
            case .failure(let error):
                self?.showError = true
                self?.errorMessage = error.localizedDescription
                 
            }
        }
    }
}

//
//  LoginViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var currentView: AppState.AppView?

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showError = true
                self?.errorMessage = error.localizedDescription
            } else {
                ///NAVEGAR HOME
                //self?.currentView = .home
            }
        }
    }
}

//
//  LoginView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Contraseña", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Iniciar Sesión") {
                viewModel.login()
            }
            .padding()

            Button("Crear Cuenta") {
                appState.currentView = .registerEmail
            }
            .padding()

            if viewModel.showError {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .onReceive(viewModel.loginSuccess) { _ in
            appState.currentView = .map // Redirigir a la vista de mapa después del inicio de sesión exitoso
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
        .environmentObject(AppState())
}

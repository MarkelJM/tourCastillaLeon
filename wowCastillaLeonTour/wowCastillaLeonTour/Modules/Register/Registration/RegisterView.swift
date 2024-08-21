//
//  RegisterView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Contraseña", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Repetir Contraseña", text: $viewModel.repeatPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Registrarse") {
                viewModel.register()
            }
            .padding()

            if viewModel.showError {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .sheet(isPresented: $viewModel.showVerificationModal) {
            VerificationEmailView(viewModel: viewModel)
        }
        .onChange(of: viewModel.isVerified) { isVerified in
            if isVerified {
                appState.currentView = .profile
            }
        }
        .padding()
    }
}

#Preview {
    RegisterView(viewModel: RegisterViewModel())
        .environmentObject(AppState())
}

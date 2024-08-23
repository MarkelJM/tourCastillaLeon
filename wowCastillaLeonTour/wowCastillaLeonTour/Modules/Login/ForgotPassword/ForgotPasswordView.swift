//
//  ForgotPasswordView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 23/8/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @ObservedObject var viewModel: ForgotPasswordViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            // Fondo de pantalla
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        appState.currentView = .login
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .padding()
                            .background(Color.mateGold)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                Text("Restablecer Contraseña")
                    .font(.largeTitle)
                    .foregroundColor(.mateGold)
                    .padding(.top, 40)

                TextField("Introduce tu Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)

                Button(action: {
                    viewModel.resetPassword(email: email)
                }) {
                    Text("Enviar Enlace de Restablecimiento")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mateRed)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.showSuccessMessage {
                    Text("Se ha enviado un enlace de restablecimiento a tu correo electrónico.")
                        .foregroundColor(.green)
                        .padding()
                }
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(20)
            .padding()
        }
    }
}

#Preview {
    ForgotPasswordView(viewModel: ForgotPasswordViewModel())
        .environmentObject(AppState())
}

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
        ZStack {
            // Fondo de pantalla
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Registra email")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.mateGold)
                        .padding(.top, 50)
                    
                    // Campo de email
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.mateWhite.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    
                    // Campo de contraseña
                    SecureField("Contraseña", text: $viewModel.password)
                        .padding()
                        .background(Color.mateWhite.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    
                    // Campo de repetir contraseña
                    SecureField("Repetir Contraseña", text: $viewModel.repeatPassword)
                        .padding()
                        .background(Color.mateWhite.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    
                    HStack {
                        Toggle(isOn: $viewModel.agreeToTerms) {
                            Text("He leído y acepto los")
                        }
                        .toggleStyle(CheckboxToggleStyle()) // Estilo personalizado para el checkbox
                        .padding(.horizontal, 10)
                        
                        Button(action: {
                            appState.currentView = .termsAndConditions
                        }) {
                            Text("Términos y Condiciones")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    // Botón de registro
                    redBackgroundButton(title: "Registrarse") {
                        viewModel.register()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                    .disabled(!viewModel.agreeToTerms) // Deshabilitar si no se aceptan los términos
                    
                    // Mostrar error si existe
                    if viewModel.showError {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .background(Color.black.opacity(0.5))  // Fondo del VStack con transparencia
                .cornerRadius(20)
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
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .blue : .secondary)
                configuration.label
            }
        }
    }
}

#Preview {
    RegisterView(viewModel: RegisterViewModel())
        .environmentObject(AppState())
}

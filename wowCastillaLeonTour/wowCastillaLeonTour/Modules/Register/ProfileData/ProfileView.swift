//
//  ProfileView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            TextField("Nombre", text: $viewModel.firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Apellido", text: $viewModel.lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Fecha de Nacimiento", selection: $viewModel.birthDate, displayedComponents: .date)
                .padding()

            TextField("Código Postal", text: $viewModel.postalCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Ciudad", text: $viewModel.city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Picker("Provincia", selection: $viewModel.province) {
                ForEach(Province.allCases) { province in
                    Text(province.rawValue).tag(province)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            AvatarSelectionView(selectedAvatar: $viewModel.avatar)
                .padding()

            Button("Guardar Perfil") {
                viewModel.saveUserProfile()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            if viewModel.showError {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchUserProfile()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}

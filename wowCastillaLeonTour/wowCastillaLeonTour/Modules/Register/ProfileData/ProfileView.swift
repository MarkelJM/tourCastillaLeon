//
//  ProfileView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

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

            Picker("Avatar", selection: $viewModel.avatar) {
                ForEach(Avatar.allCases) { avatar in
                    Text(avatar.rawValue).tag(avatar)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Guardar Perfil") {
                viewModel.saveUserProfile()
            }
            .padding()

            if viewModel.showError {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}
#Preview {
    ProfileView()
}

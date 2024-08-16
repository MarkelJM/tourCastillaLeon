//
//  SettingProfileView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 16/8/24.
//

import SwiftUI

struct SettingProfileView: View {
    @StateObject var viewModel = SettingProfileViewModel()
    @State private var isEditing = false
    @State private var editedFirstName = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Avatar
                Image(viewModel.user?.avatar.rawValue ?? "normalMutila")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
                
                // Profile Information
                if isEditing {
                    TextField("Nombre", text: $editedFirstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                } else {
                    Text("Nombre: \(viewModel.user?.firstName ?? "")")
                    Text("Apellido: \(viewModel.user?.lastName ?? "")")
                    Text("Email: \(viewModel.user?.email ?? "")")
                    Text("Fecha de Nacimiento: \(viewModel.user?.birthDate.formatted(date: .abbreviated, time: .omitted) ?? "")")
                    Text("Código Postal: \(viewModel.user?.postalCode ?? "")")
                    Text("Ciudad: \(viewModel.user?.city ?? "")")
                    Text("Provincia: \(viewModel.user?.province.rawValue ?? "")")
                }
                
                // Task Statistics
                HStack {
                    VStack {
                        Text("Ávila")
                        Text("\(viewModel.user?.avilaCityTaskIDs.count ?? 0)")
                    }
                    VStack {
                        Text("Burgos")
                        Text("\(viewModel.user?.burgosCityTaskIDs.count ?? 0)")
                    }
                    VStack {
                        Text("León")
                        Text("\(viewModel.user?.leonCityTaskIDs.count ?? 0)")
                    }
                }
                HStack {
                    VStack {
                        Text("Palencia")
                        Text("\(viewModel.user?.palenciaCityTaskIDs.count ?? 0)")
                    }
                    VStack {
                        Text("Salamanca")
                        Text("\(viewModel.user?.salamancaCityTaskIDs.count ?? 0)")
                    }
                    VStack {
                        Text("Segovia")
                        Text("\(viewModel.user?.segoviaCityTaskIDs.count ?? 0)")
                    }
                }
                HStack {
                    VStack {
                        Text("Soria")
                        Text("\(viewModel.user?.soriaCityTaskIDs.count ?? 0)")
                    }
                    VStack {
                        Text("Valladolid")
                        Text("\(viewModel.user?.valladolidCityTaskIDs.count ?? 0)")
                    }
                    VStack {
                        Text("Zamora")
                        Text("\(viewModel.user?.zamoraCityTaskIDs.count ?? 0)")
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Perfil")
            .navigationBarItems(leading: Button(action: {
                if isEditing {
                    viewModel.updateUserName(editedFirstName)
                } else {
                    editedFirstName = viewModel.user?.firstName ?? ""
                }
                isEditing.toggle()
            }) {
                Image(systemName: "pencil")
            })
            .onAppear {
                viewModel.fetchUserProfile()
            }
            .padding()
        }
    }
}

struct SettingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SettingProfileView(viewModel: SettingProfileViewModel())
    }
}

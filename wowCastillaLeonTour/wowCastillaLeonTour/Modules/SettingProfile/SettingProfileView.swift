//
//  SettingProfileView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 16/8/24.
//


import SwiftUI

struct SettingProfileView: View {
    @StateObject var viewModel = SettingProfileViewModel()
    @State private var showEditProfileModal = false
    @State private var showPolicyView = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Fondo de pantalla
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 20) {
                    // Botón "Cerrar Sesión" en la parte superior izquierda
                    HStack {
                        Button(action: {
                            KeychainManager.shared.delete(key: "userUID")
                            appState.currentView = .login
                        }) {
                            Text("Cerrar Sesión")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding([.top, .leading], 20)

                        Spacer()
                    }

                    // Avatar e información de perfil
                    Image(viewModel.user?.avatar.rawValue ?? "normalMutila")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.mateRed, lineWidth: 2))
                        .padding(.top, 40)

                    VStack(alignment: .leading, spacing: 10) {
                        ProfileInfoRow(label: "Nombre:", value: viewModel.user?.firstName ?? "")
                        ProfileInfoRow(label: "Apellido:", value: viewModel.user?.lastName ?? "")
                        ProfileInfoRow(label: "Fecha de Nacimiento:", value: viewModel.user?.birthDate.formatted(date: .abbreviated, time: .omitted) ?? "")
                        ProfileInfoRow(label: "Código Postal:", value: viewModel.user?.postalCode ?? "")
                        ProfileInfoRow(label: "Ciudad:", value: viewModel.user?.city ?? "")
                        ProfileInfoRow(label: "Provincia:", value: viewModel.user?.province.rawValue ?? "")
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(15)

                    VStack(spacing: 10) {
                        Text("Estadísticas por Desafío")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.mateGold)

                        if let challenges = viewModel.user?.challenges {
                            ForEach(challenges.keys.sorted(), id: \.self) { challenge in
                                let taskCount = challenges[challenge]?.count ?? 0
                                ChallengeStatView(challenge: challenge, count: taskCount)
                            }
                        } else {
                            Text("No hay desafíos completados")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)

                    // Botón "Términos y Condiciones"
                    Button(action: {
                        showPolicyView = true
                    }) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.white)
                            Text("Términos y Condiciones")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.bottom, 100)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                .padding()
                .background(Color.black.opacity(0.65))
                .cornerRadius(20)
                .padding()
                .padding(.top, 40)
            }

            // Botón de edición en la parte superior derecha
            Button(action: {
                viewModel.startEditing()
                showEditProfileModal = true
            }) {
                Image(systemName: "pencil.circle")
                    .font(.largeTitle)
                    .foregroundColor(.mateGold)
                    .padding(.trailing, 20)
                    .padding(.top, 100)
            }
        }
        .sheet(isPresented: $showEditProfileModal) {
            EditProfileView(
                editedFirstName: $viewModel.editedFirstName,
                editedLastName: $viewModel.editedLastName,
                editedPostalCode: $viewModel.editedPostalCode,
                editedCity: $viewModel.editedCity,
                editedProvince: $viewModel.editedProvince,
                editedAvatar: $viewModel.editedAvatar,
                onSave: {
                    viewModel.saveProfileChanges()
                    showEditProfileModal = false
                },
                onCancel: {
                    showEditProfileModal = false
                }
            )
            .background(Color.black.opacity(0.2))
            .cornerRadius(20)
            .padding()
        }
        .sheet(isPresented: $showPolicyView) {
            PolicyView()
        }
        .onAppear {
            viewModel.fetchUserProfile()
        }
    }
}

struct ProfileInfoRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.mateRed)
            Spacer()
            Text(value)
                .foregroundColor(.mateWhite)
        }
        .padding(.vertical, 5)
    }
}

struct ChallengeStatView: View {
    var challenge: String
    var count: Int

    var body: some View {
        VStack {
            Text(challenge)
                .font(.headline)
                .foregroundColor(.mateBlue)
            Text("\(count) tareas completadas")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.mateRed)
        }
    }
}

struct SettingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SettingProfileView(viewModel: SettingProfileViewModel())
    }
}





/*
import SwiftUI

struct SettingProfileView: View {
    @StateObject var viewModel = SettingProfileViewModel()
    @State private var isEditing = false
    @State private var editedFirstName = ""

    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all) // Fondo oscuro, limpio y minimalista

                    VStack(spacing: 20) {
                        // Avatar
                        Image(viewModel.user?.avatar.rawValue ?? "normalMutila")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.mateRed, lineWidth: 2)) // Borde sutil en rojo mate
                            .padding()

                        // Profile Information
                        VStack(alignment: .leading, spacing: 10) {
                            if isEditing {
                                TextField("Nombre", text: $editedFirstName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                            } else {
                                ProfileInfoRow(label: "Nombre:", value: viewModel.user?.firstName ?? "")
                                ProfileInfoRow(label: "Apellido:", value: viewModel.user?.lastName ?? "")
                                ProfileInfoRow(label: "Fecha de Nacimiento:", value: viewModel.user?.birthDate.formatted(date: .abbreviated, time: .omitted) ?? "")
                                ProfileInfoRow(label: "Código Postal:", value: viewModel.user?.postalCode ?? "")
                                ProfileInfoRow(label: "Ciudad:", value: viewModel.user?.city ?? "")
                                ProfileInfoRow(label: "Provincia:", value: viewModel.user?.province.rawValue ?? "")
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.7)) // Fondo semitransparente
                        .cornerRadius(15)

                        // Task Statistics
                        VStack(spacing: 10) {
                            Text("Estadísticas por Ciudad")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.mateGold)

                            HStack(spacing: 20) {
                                ProvinceStatView(province: "Ávila", count: viewModel.user?.avilaCityTaskIDs.count ?? 0)
                                ProvinceStatView(province: "Burgos", count: viewModel.user?.burgosCityTaskIDs.count ?? 0)
                                ProvinceStatView(province: "León", count: viewModel.user?.leonCityTaskIDs.count ?? 0)
                            }

                            HStack(spacing: 20) {
                                ProvinceStatView(province: "Palencia", count: viewModel.user?.palenciaCityTaskIDs.count ?? 0)
                                ProvinceStatView(province: "Salamanca", count: viewModel.user?.salamancaCityTaskIDs.count ?? 0)
                                ProvinceStatView(province: "Segovia", count: viewModel.user?.segoviaCityTaskIDs.count ?? 0)
                            }

                            HStack(spacing: 20) {
                                ProvinceStatView(province: "Soria", count: viewModel.user?.soriaCityTaskIDs.count ?? 0)
                                ProvinceStatView(province: "Valladolid", count: viewModel.user?.valladolidCityTaskIDs.count ?? 0)
                                ProvinceStatView(province: "Zamora", count: viewModel.user?.zamoraCityTaskIDs.count ?? 0)
                            }
                        }

                        Spacer()
                    }
                    .navigationTitle(Text("Perfil").foregroundColor(.mateGold)) // Título en mateGold
                    .navigationBarItems(trailing: Button(action: {
                        if isEditing {
                            viewModel.updateUserName(editedFirstName)
                        } else {
                            editedFirstName = viewModel.user?.firstName ?? ""
                        }
                        isEditing.toggle()
                    }) {
                        Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle")
                            .foregroundColor(.mateGold) // Botón en mateGold
                    })
                    .onAppear {
                        viewModel.fetchUserProfile()
                    }
                    .padding()
                }
            }
        }
    }
}

struct ProfileInfoRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.mateRed)
            Spacer()
            Text(value)
                .foregroundColor(.mateWhite)
        }
        .padding(.vertical, 5)
    }
}

struct ProvinceStatView: View {
    var province: String
    var count: Int

    var body: some View {
        VStack {
            Text(province)
                .font(.headline)
                .foregroundColor(.mateBlue)
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.mateRed)
        }
    }
}

struct SettingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SettingProfileView(viewModel: SettingProfileViewModel())
    }
}
*/

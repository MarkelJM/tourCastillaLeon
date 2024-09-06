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
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 20) {
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

                    Toggle(isOn: $viewModel.isSoundEnabled) {
                        Text("Activar efectos de sonido")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .onChange(of: viewModel.isSoundEnabled) { newValue in
                        viewModel.toggleSoundEnabled()
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.horizontal)

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





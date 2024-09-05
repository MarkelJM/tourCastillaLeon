//
//  SettingProfileViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 16/8/24.
//


import SwiftUI
import Combine

class SettingProfileViewModel: BaseViewModel {
    @Published var editedFirstName: String = ""
    @Published var editedLastName: String = ""
    @Published var editedPostalCode: String = ""
    @Published var editedCity: String = ""
    @Published var editedProvince: Province = .other
    @Published var editedAvatar: Avatar = .boy  // Estado para el avatar seleccionado
    @Published var isEditing = false
    @Published var isSoundEnabled: Bool = true

    //private let userDefaultsManager = UserDefaultsManager()

    override init() {
        super.init()
        // Cargar la configuración de sonido al iniciar el ViewModel
        self.isSoundEnabled = userDefaultsManager.isSoundEnabled()
    }

    // Método para actualizar la configuración de sonido
    func toggleSoundEnabled() {
        isSoundEnabled.toggle()  // Cambiar el estado actual
        userDefaultsManager.setSoundEnabled(isSoundEnabled)
    }

    // Inicializar los valores editables con los datos del usuario actual cuando se inicie la edición
    func startEditing() {
        guard let user = user else { return }
        editedFirstName = user.firstName
        editedLastName = user.lastName
        editedPostalCode = user.postalCode
        editedCity = user.city
        editedProvince = user.province
        editedAvatar = user.avatar  // Cargar el avatar actual
    }

    // Guardar los cambios y actualizar el perfil del usuario en Firestore
    func saveProfileChanges() {
        guard var user = user else { return }
        user.firstName = editedFirstName
        user.lastName = editedLastName
        user.postalCode = editedPostalCode
        user.city = editedCity
        user.province = editedProvince
        user.avatar = editedAvatar  // Guardar el avatar seleccionado

        performProfileUpdate(user: user)
    }

    // Método para actualizar el perfil del usuario en Firestore
    private func performProfileUpdate(user: User) {
        firestoreManager.updateUserProfile(user: user)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error al actualizar el perfil: \(error.localizedDescription)"
                case .finished:
                    self.alertMessage = "Perfil actualizado correctamente."
                }
                self.showAlert = true
            } receiveValue: { _ in
                self.isEditing = false // Salir del modo edición después de guardar
            }
            .store(in: &cancellables)
    }
}



/*
import SwiftUI
import Combine

class SettingProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let dataManager = SettingProfileDataManager()
    var cancellables = Set<AnyCancellable>()

    func fetchUserProfile() {
        dataManager.fetchUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }
    
    func updateUserName(_ newName: String) {
        guard var user = user else { return }
        user.firstName = newName
        updateUserProfile(user: user)
    }

    private func updateUserProfile(user: User) {
        dataManager.updateUserProfile(user: user)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error updating user profile: \(error.localizedDescription)")
                case .finished:
                    print("User profile updated successfully")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
*/

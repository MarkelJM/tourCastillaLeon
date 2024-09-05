//
//  SpecialPrizeListViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//
/*
import SwiftUI
import Combine

class SpecialPrizeListViewModel: BaseViewModel {
    @Published var specialPrizes: [SpecialPrize] = []
    @Published var selectedSpecialPrizeId: String?
    @Published var isUserLoaded: Bool = false

    private let dataManager = SpecialPrizeDataManager()

    override init() {
        super.init()
        fetchUserProfile() // Asegúrate de cargar el perfil del usuario al iniciar
    }
    
    override func fetchUserProfile() {
        super.fetchUserProfile()
        self.$user
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.isUserLoaded = true
            }
            .store(in: &self.cancellables)
    }
    
    func fetchSpecialPrizes() {
        dataManager.fetchSpecialPrizes()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { specialPrizes in
                self.specialPrizes = specialPrizes
            }
            .store(in: &self.cancellables)
    }
    
    func canAttemptSpecialTask(prize: SpecialPrize) -> Bool {
        guard let user = user else {
            print("User is nil, cannot proceed with special task attempt.")
            return false
        }

        let completedTasksInProvince = completedTasks(in: prize.province, for: user)
        
        if completedTasksInProvince >= prize.tasksAmount {
            self.selectedSpecialPrizeId = prize.id
            return true
        } else {
            let tasksNeeded = prize.tasksAmount - completedTasksInProvince
            if user.coinTaskIDs.count >= tasksNeeded * 2 {
                alertMessage = "Te faltan \(tasksNeeded) tareas. ¿Quieres gastar \(tasksNeeded * 2) monedas para intentarlo?"
                showAlert = true
                return false
            } else {
                alertMessage = "No tienes suficientes monedas para intentarlo."
                showAlert = true
                return false
            }
        }
    }

    func completedTasks(in province: String, for user: User) -> Int {
        let completedTasks: Int
        switch province {
        case "Ávila": completedTasks = user.avilaCityTaskIDs.count
        case "Burgos": completedTasks = user.burgosCityTaskIDs.count
        case "León": completedTasks = user.leonCityTaskIDs.count
        case "Palencia": completedTasks = user.palenciaCityTaskIDs.count
        case "Salamanca": completedTasks = user.salamancaCityTaskIDs.count
        case "Segovia": completedTasks = user.segoviaCityTaskIDs.count
        case "Soria": completedTasks = user.soriaCityTaskIDs.count
        case "Valladolid": completedTasks = user.valladolidCityTaskIDs.count
        case "Zamora": completedTasks = user.zamoraCityTaskIDs.count
        default: completedTasks = 0
        }
        
        print("Province: \(province), Completed Tasks: \(completedTasks)")
        return completedTasks
    }
    
    func useCoinsForTask(prize: SpecialPrize) -> Bool {
        guard var user = user else { return false }

        let completedTasksInProvince = completedTasks(in: prize.province, for: user)
        let tasksNeeded = prize.tasksAmount - completedTasksInProvince

        if user.coinTaskIDs.count >= tasksNeeded * 2 {
            // Remover monedas usadas
            let coinsToUse = user.coinTaskIDs.prefix(tasksNeeded * 2)
            user.coinTaskIDs.removeFirst(tasksNeeded * 2)
            user.usedCoinTaskIDs.append(contentsOf: coinsToUse)
            
            // Actualizar el usuario en Firestore y continuar a la tarea especial
            self.selectedSpecialPrizeId = prize.id
            return true
        } else {
            alertMessage = "No tienes suficientes monedas para intentarlo."
            showAlert = true
            return false
        }
    }
}
*/

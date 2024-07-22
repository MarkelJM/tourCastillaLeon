//
//  TakePhotoViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI
import Combine

class TakePhotoViewModel: ObservableObject {
    @Published var takePhotos: [TakePhoto] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = true

    private var cancellables = Set<AnyCancellable>()
    private let dataManager = TakePhotoDataManager()
    private let activityId: String

    init(activityId: String) {
        self.activityId = activityId
        fetchTakePhotoById(activityId)
    }

    func fetchTakePhotoById(_ id: String) {
        isLoading = true
        dataManager.fetchTakePhotoById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { takePhoto in
                self.takePhotos = [takePhoto]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}

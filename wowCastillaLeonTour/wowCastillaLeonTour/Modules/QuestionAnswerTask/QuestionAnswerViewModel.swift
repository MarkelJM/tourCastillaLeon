//
//  QuestionAnswerViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI
import Combine

class QuestionAnswerViewModel: ObservableObject {
    @Published var questionAnswers: [QuestionAnswer] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = true

    private var cancellables = Set<AnyCancellable>()
    private let dataManager = QuestionAnswerDataManager()
    private let activityId: String

    init(activityId: String) {
        self.activityId = activityId
        fetchQuestionAnswerById(activityId)
    }

    func fetchQuestionAnswerById(_ id: String) {
        isLoading = true
        dataManager.fetchQuestionAnswerById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { questionAnswer in
                self.questionAnswers = [questionAnswer]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}

//
//  QuestionAnswerView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI

struct QuestionAnswerView: View {
    @StateObject var viewModel: QuestionAnswerViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Cargando pregunta...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let questionAnswer = viewModel.questionAnswer {
                VStack(spacing: 20) {
                    Text(questionAnswer.question)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    ForEach(questionAnswer.options, id: \.self) { option in
                        Button(action: {
                            viewModel.selectedOption = option
                        }) {
                            Text(option)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(viewModel.selectedOption == option ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                    }
                    
                    Button("Comprobar") {
                        viewModel.checkAnswer()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $viewModel.showResultModal) {
                    ResultQuestionView(viewModel: viewModel)
                }
            } else {
                Text("No hay pregunta disponible")
            }
        }
        .onAppear {
            viewModel.fetchQuestionAnswer()
        }
    }
}

struct ResultQuestionView: View {
    @ObservedObject var viewModel: QuestionAnswerViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.alertMessage)
                .font(.title)
                .padding()

            Button("Continuar") {
                viewModel.showResultModal = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    QuestionAnswerView(viewModel: QuestionAnswerViewModel(activityId: "mockId"))
}
